from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime


# Schemas de Usuario
class UsuarioBase(BaseModel):
    email: EmailStr
    nombre: str
    rol: str


class UsuarioCreate(UsuarioBase):
    cognito_user_id: str
    activo: bool = True


class UsuarioUpdate(BaseModel):
    nombre: Optional[str] = None
    rol: Optional[str] = None
    activo: Optional[bool] = None


class Usuario(UsuarioBase):
    id: int
    cognito_user_id: str
    activo: bool
    nombre_empresa: Optional[str] = None
    telefono: Optional[str] = None
    direccion: Optional[str] = None
    ciudad: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class UsuarioConDifusoras(Usuario):
    """Usuario con lista de difusoras asignadas"""
    difusoras: List[str] = []  # Lista de siglas de difusoras


# Schemas de asignación de difusoras
class UsuarioDifusoraBase(BaseModel):
    difusora_id: int


class UsuarioDifusoraCreate(UsuarioDifusoraBase):
    usuario_id: int


class UsuarioDifusora(UsuarioDifusoraBase):
    id: int
    usuario_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True


# Schemas de autenticación
class TokenResponse(BaseModel):
    access_token: str
    id_token: str
    refresh_token: str
    token_type: str = "Bearer"


class UserInfo(BaseModel):
    """Información del usuario autenticado"""
    id: int
    email: str
    nombre: str
    rol: str
    difusoras: List[str] = []  # Siglas de difusoras asignadas
    is_admin: bool = False


class UsuarioInvite(BaseModel):
    """Schema para invitar un nuevo usuario"""
    email: EmailStr
    nombre: str
    rol: str = "operador"  # admin, manager, operador
    difusoras_ids: List[int] = []  # IDs de difusoras a asignar


class UsuarioInviteResponse(BaseModel):
    """Respuesta al invitar un usuario"""
    usuario: UsuarioConDifusoras
    temporary_password: str
    message: str
    email_sent: bool = False
    email_message: Optional[str] = None


class PerfilUpdate(BaseModel):
    """Schema para actualizar perfil propio"""
    nombre: Optional[str] = None
    email: Optional[EmailStr] = None


class ChangePasswordRequest(BaseModel):
    """Schema para cambio de contraseña"""
    current_password: str
    new_password: str
    confirm_password: str


class FirstAdminCreate(BaseModel):
    """Schema para crear una cuenta de administrador"""
    email: EmailStr
    nombre: str
    password: str
    confirm_password: str
    nombre_empresa: Optional[str] = None
    telefono: Optional[str] = None
    direccion: Optional[str] = None
    ciudad: Optional[str] = None


class ForgotPasswordRequest(BaseModel):
    """Schema para solicitar recuperación de contraseña"""
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    """Schema para restablecer contraseña con código"""
    email: EmailStr
    code: str
    new_password: str
    confirm_password: str

