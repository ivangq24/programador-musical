"""
add difusora and clave to categorias

Revision ID: 9caddcadd001
Revises: 9f7d4fde85e9
Create Date: 2025-10-30
"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '9caddcadd001'
down_revision = '9f7d4fde85e9'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('categorias', sa.Column('difusora', sa.String(length=10), nullable=True))
    op.add_column('categorias', sa.Column('clave', sa.String(length=50), nullable=True))


def downgrade() -> None:
    op.drop_column('categorias', 'clave')
    op.drop_column('categorias', 'difusora')


