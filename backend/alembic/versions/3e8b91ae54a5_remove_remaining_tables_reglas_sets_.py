"""remove_remaining_tables_reglas_sets_reglas_orden_asignacion

Revision ID: 3e8b91ae54a5
Revises: eb22ba79a061
Create Date: 2025-10-29 08:49:41.881623

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '3e8b91ae54a5'
down_revision = 'eb22ba79a061'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Eliminar tablas restantes de reglas, sets de reglas y orden de asignación
    # Usar CASCADE para eliminar dependencias automáticamente
    op.execute('DROP TABLE IF EXISTS reglas CASCADE')
    op.execute('DROP TABLE IF EXISTS sets_reglas CASCADE')
    op.execute('DROP TABLE IF EXISTS orden_asignacion CASCADE')


def downgrade() -> None:
    # Recrear tablas para rollback
    op.create_table('sets_reglas',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('politica_id', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('habilitado', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('orden', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='sets_reglas_pkey'),
        sa.ForeignKeyConstraint(['politica_id'], ['politicas_programacion.id'], name='sets_reglas_politica_id_fkey', ondelete='CASCADE')
    )
    op.create_index('ix_sets_reglas_id', 'sets_reglas', ['id'], unique=False)
    
    op.create_table('reglas',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('set_regla_id', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('tipo', sa.VARCHAR(length=50), autoincrement=False, nullable=False),
        sa.Column('parametros', sa.JSON(), autoincrement=False, nullable=True),
        sa.Column('habilitada', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('orden', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='reglas_pkey'),
        sa.ForeignKeyConstraint(['set_regla_id'], ['sets_reglas.id'], name='reglas_set_regla_id_fkey', ondelete='CASCADE')
    )
    op.create_index('ix_reglas_id', 'reglas', ['id'], unique=False)
    
    op.create_table('orden_asignacion',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('politica_id', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('tipo', sa.VARCHAR(length=50), autoincrement=False, nullable=False),
        sa.Column('parametros', sa.JSON(), autoincrement=False, nullable=True),
        sa.Column('habilitado', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('orden', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='orden_asignacion_pkey'),
        sa.ForeignKeyConstraint(['politica_id'], ['politicas_programacion.id'], name='orden_asignacion_politica_id_fkey', ondelete='CASCADE')
    )
    op.create_index('ix_orden_asignacion_id', 'orden_asignacion', ['id'], unique=False)
