from pydantic_settings import BaseSettings
from pydantic import Field, computed_field
from typing import Optional
import os

class Settings(BaseSettings):
    # API Configuration
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "Programador Musical"
    
    # Database Configuration - Individual components for AWS Secrets Manager
    DATABASE_URL: Optional[str] = Field(default=None)
    DATABASE_HOST: str = Field(default="db")
    DATABASE_NAME: str = Field(default="programador-musical")
    DATABASE_USERNAME: str = Field(default="postgres")
    DATABASE_PASSWORD: str = Field(default="postgres")
    DATABASE_PORT: int = Field(default=5432)
    
    # Security
    SECRET_KEY: str = Field(default="dev-secret-key-change-in-production")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # CORS
    BACKEND_CORS_ORIGINS: list = ["http://localhost:3000"]
    
    # Environment
    ENVIRONMENT: str = Field(default="development")
    
    # AWS Cognito Configuration
    COGNITO_USER_POOL_ID: Optional[str] = Field(default=None)
    COGNITO_CLIENT_ID: Optional[str] = Field(default=None)
    COGNITO_REGION: str = Field(default="us-east-1")
    
    # AWS SES Configuration (para envío de emails)
    SES_FROM_EMAIL: str = Field(default="noreply@programador-musical.com", description="Email remitente para SES (debe estar verificado)")
    SES_PRODUCTION_MODE: bool = Field(default=False, description="Si está en True, no requiere verificar cada email destino (modo producción)")
    
    # Frontend URL (para links en emails)
    FRONTEND_URL: str = Field(default="http://localhost:3000", description="URL del frontend para links en emails")
    
    @computed_field
    @property
    def database_url(self) -> str:
        """Construct database URL from components or use provided URL"""
        if self.DATABASE_URL:
            return self.DATABASE_URL
        
        return f"postgresql://{self.DATABASE_USERNAME}:{self.DATABASE_PASSWORD}@{self.DATABASE_HOST}:{self.DATABASE_PORT}/{self.DATABASE_NAME}"
    
    class Config:
        env_file = ".env"

settings = Settings()
