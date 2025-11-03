"""add_descripcion_to_reglas

Revision ID: 9f7d4fde85e9
Revises: 51dd1aa05223
Create Date: 2025-10-29 14:10:06.523418

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '9f7d4fde85e9'
down_revision = '51dd1aa05223'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Agregar columna descripcion a la tabla reglas
    op.add_column('reglas', sa.Column('descripcion', sa.Text(), nullable=True))


def downgrade() -> None:
    # Eliminar columna descripcion de la tabla reglas
    op.drop_column('reglas', 'descripcion')
