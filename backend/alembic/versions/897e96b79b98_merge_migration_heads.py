"""merge_migration_heads

Revision ID: 897e96b79b98
Revises: 20250112000000, 9caddcadd001
Create Date: 2025-11-12 04:13:28.963477

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '897e96b79b98'
down_revision = ('20250112000000', '9caddcadd001')
branch_labels = None
depends_on = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
