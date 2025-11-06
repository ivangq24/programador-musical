#!/bin/bash

# Script to get your current public IP address and update Terraform configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

get_public_ip() {
    log_info "Detecting your public IP address..."
    
    # Try multiple services to get public IP
    IP=""
    
    # Try ipify.org
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 https://api.ipify.org 2>/dev/null || echo "")
    fi
    
    # Try icanhazip.com as backup
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 https://icanhazip.com 2>/dev/null | tr -d '\n' || echo "")
    fi
    
    # Try ifconfig.me as backup
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 https://ifconfig.me 2>/dev/null || echo "")
    fi
    
    if [ -z "$IP" ]; then
        log_error "Could not detect your public IP address"
        log_info "Please manually set your IP in terraform.tfvars"
        exit 1
    fi
    
    # Validate IP format
    if [[ ! $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_error "Invalid IP address detected: $IP"
        exit 1
    fi
    
    log_success "Your public IP address: $IP"
    echo "$IP"
}

update_terraform_vars() {
    local ip=$1
    local tfvars_file="aws/terraform/terraform.tfvars"
    
    log_info "Updating Terraform variables with your IP..."
    
    if [ ! -f "$tfvars_file" ]; then
        log_info "Creating terraform.tfvars from example..."
        cp aws/terraform/terraform.tfvars.example "$tfvars_file"
    fi
    
    # Update the IP address in terraform.tfvars
    if grep -q "allowed_ip_addresses" "$tfvars_file"; then
        # Replace existing line - escape special characters
        sed -i.bak "s|allowed_ip_addresses = \[.*\]|allowed_ip_addresses = [\"${ip}/32\"]|" "$tfvars_file"
    else
        # Add new line
        echo "" >> "$tfvars_file"
        echo "# IP Access Restriction" >> "$tfvars_file"
        echo "restrict_to_ip = true" >> "$tfvars_file"
        echo "allowed_ip_addresses = [\"${ip}/32\"]" >> "$tfvars_file"
    fi
    
    # Ensure restrict_to_ip is set to true
    if grep -q "restrict_to_ip" "$tfvars_file"; then
        sed -i.bak "s/restrict_to_ip = .*/restrict_to_ip = true/" "$tfvars_file"
    else
        echo "restrict_to_ip = true" >> "$tfvars_file"
    fi
    
    log_success "Updated $tfvars_file with IP: ${ip}/32"
}

show_current_config() {
    local tfvars_file="aws/terraform/terraform.tfvars"
    
    if [ -f "$tfvars_file" ]; then
        log_info "Current IP configuration:"
        grep -E "(restrict_to_ip|allowed_ip_addresses)" "$tfvars_file" || log_warning "No IP restriction configured"
    else
        log_warning "No terraform.tfvars file found"
    fi
}

add_additional_ip() {
    local new_ip=$1
    local tfvars_file="aws/terraform/terraform.tfvars"
    
    if [ -z "$new_ip" ]; then
        log_error "Please provide an IP address"
        echo "Usage: $0 add-ip <ip_address>"
        exit 1
    fi
    
    # Validate IP format
    if [[ ! $new_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_error "Invalid IP address format: $new_ip"
        exit 1
    fi
    
    if [ ! -f "$tfvars_file" ]; then
        log_error "terraform.tfvars file not found. Run '$0 update' first."
        exit 1
    fi
    
    # Get current IPs
    current_ips=$(grep "allowed_ip_addresses" "$tfvars_file" | sed 's/.*\[\(.*\)\].*/\1/' | tr -d '"')
    
    # Add new IP
    if [[ $current_ips == *"${new_ip}/32"* ]]; then
        log_warning "IP ${new_ip} is already in the allowed list"
    else
        new_list="${current_ips}, \"${new_ip}/32\""
        sed -i.bak "s/allowed_ip_addresses = \[.*\]/allowed_ip_addresses = [${new_list}]/" "$tfvars_file"
        log_success "Added IP ${new_ip}/32 to allowed list"
    fi
}

remove_ip() {
    local remove_ip=$1
    local tfvars_file="aws/terraform/terraform.tfvars"
    
    if [ -z "$remove_ip" ]; then
        log_error "Please provide an IP address to remove"
        echo "Usage: $0 remove-ip <ip_address>"
        exit 1
    fi
    
    if [ ! -f "$tfvars_file" ]; then
        log_error "terraform.tfvars file not found"
        exit 1
    fi
    
    # Remove the IP from the list
    sed -i.bak "s/, \"${remove_ip}\/32\"//g; s/\"${remove_ip}\/32\", //g; s/\"${remove_ip}\/32\"//g" "$tfvars_file"
    log_success "Removed IP ${remove_ip}/32 from allowed list"
}

# Main script
case "${1:-update}" in
    "update")
        MY_IP=$(get_public_ip)
        update_terraform_vars "$MY_IP"
        show_current_config
        log_info "Next steps:"
        echo "1. Review aws/terraform/terraform.tfvars"
        echo "2. Deploy with: ./aws/deploy-to-aws.sh deploy"
        ;;
    "show")
        show_current_config
        ;;
    "add-ip")
        add_additional_ip "$2"
        show_current_config
        ;;
    "remove-ip")
        remove_ip "$2"
        show_current_config
        ;;
    "get-ip")
        get_public_ip
        ;;
    "help"|*)
        echo "IP Address Management for AWS Deployment"
        echo ""
        echo "Usage: $0 <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  update              - Detect your IP and update terraform.tfvars (default)"
        echo "  show                - Show current IP configuration"
        echo "  get-ip              - Just show your current public IP"
        echo "  add-ip <ip>         - Add additional IP to allowed list"
        echo "  remove-ip <ip>      - Remove IP from allowed list"
        echo "  help                - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 update                    # Auto-detect and set your IP"
        echo "  $0 add-ip 203.0.113.1       # Allow additional IP"
        echo "  $0 remove-ip 203.0.113.1    # Remove IP from list"
        echo "  $0 show                      # Show current configuration"
        echo ""
        echo "Note: IP addresses are automatically converted to CIDR format (/32)"
        ;;
esac