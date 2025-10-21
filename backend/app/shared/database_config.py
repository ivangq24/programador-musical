"""
Shared database configuration to avoid table redefinition issues
"""
from sqlalchemy import MetaData
from sqlalchemy.ext.declarative import declarative_base

# Create a shared metadata instance
metadata = MetaData()

# Create a shared declarative base
Base = declarative_base(metadata=metadata)

# Export commonly used database components
__all__ = ['Base', 'metadata']
