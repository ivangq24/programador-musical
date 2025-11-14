"""Add auth tables

Revision ID: auth_20250606
Revises: 9f7d4fde85e9
Create Date: 2025-11-06 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'auth_20250606'
down_revision = '9f7d4fde85e9'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Crear tabla de usuarios
    op.create_table(
        'usuarios',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('cognito_user_id', sa.String(length=255), nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('nombre', sa.String(length=255), nullable=False),
        sa.Column('rol', sa.String(length=50), nullable=False, comment='admin, manager, operador'),
        sa.Column('activo', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('cognito_user_id'),
        sa.UniqueConstraint('email')
    )
    op.create_index('ix_usuarios_id', 'usuarios', ['id'], unique=False)
    op.create_index('ix_usuarios_cognito_user_id', 'usuarios', ['cognito_user_id'], unique=True)
    op.create_index('ix_usuarios_email', 'usuarios', ['email'], unique=True)
    
    # Crear tabla de asignación usuario-difusora
    op.create_table(
        'usuario_difusoras',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('usuario_id', sa.Integer(), nullable=False),
        sa.Column('difusora_id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=True),
        sa.ForeignKeyConstraint(['usuario_id'], ['usuarios.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['difusora_id'], ['difusoras.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('usuario_id', 'difusora_id', name='uq_usuario_difusora')
    )
    op.create_index('ix_usuario_difusoras_id', 'usuario_difusoras', ['id'], unique=False)
    op.create_index('idx_usuario_difusoras_usuario', 'usuario_difusoras', ['usuario_id'], unique=False)
    op.create_index('idx_usuario_difusoras_difusora', 'usuario_difusoras', ['difusora_id'], unique=False)


def downgrade() -> None:
    # Eliminar índices
    op.drop_index('idx_usuario_difusoras_difusora', table_name='usuario_difusoras')
    op.drop_index('idx_usuario_difusoras_usuario', table_name='usuario_difusoras')
    op.drop_index('ix_usuario_difusoras_id', table_name='usuario_difusoras')
    op.drop_index('ix_usuarios_email', table_name='usuarios')
    op.drop_index('ix_usuarios_cognito_user_id', table_name='usuarios')
    op.drop_index('ix_usuarios_id', table_name='usuarios')
    
    # Eliminar tablas
    op.drop_table('usuario_difusoras')
    op.drop_table('usuarios')

