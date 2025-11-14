"""add_admin_fields_to_usuario

Revision ID: 20250108000000
Revises: auth_20250606
Create Date: 2025-01-08 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '20250108000000'
down_revision = 'auth_20250606'
branch_labels = None
depends_on = None


def upgrade():
    # Agregar campos adicionales para administrador
    op.add_column('usuarios', sa.Column('nombre_empresa', sa.String(255), nullable=True, comment='Nombre de la empresa/organización'))
    op.add_column('usuarios', sa.Column('telefono', sa.String(50), nullable=True, comment='Teléfono de contacto'))
    op.add_column('usuarios', sa.Column('direccion', sa.String(500), nullable=True, comment='Dirección'))
    op.add_column('usuarios', sa.Column('ciudad', sa.String(100), nullable=True, comment='Ciudad'))


def downgrade():
    # Eliminar campos adicionales
    op.drop_column('usuarios', 'ciudad')
    op.drop_column('usuarios', 'direccion')
    op.drop_column('usuarios', 'telefono')
    op.drop_column('usuarios', 'nombre_empresa')

