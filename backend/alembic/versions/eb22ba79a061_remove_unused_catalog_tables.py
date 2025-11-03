"""remove_unused_catalog_tables

Revision ID: eb22ba79a061
Revises: 16c976d2801b
Create Date: 2025-10-28 22:51:46.198400

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'eb22ba79a061'
down_revision = '16c976d2801b'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Eliminar tablas de catálogos no utilizados
    op.drop_index('ix_tipos_clasificacion_id', table_name='tipos_clasificacion')
    op.drop_table('tipos_clasificacion')
    
    op.drop_index('ix_sellos_discograficos_id', table_name='sellos_discograficos')
    op.drop_table('sellos_discograficos')
    
    op.drop_index('ix_personas_id', table_name='personas')
    op.drop_table('personas')
    
    op.drop_index('ix_interpretes_id', table_name='interpretes')
    op.drop_table('interpretes')
    
    op.drop_index('ix_dayparts_id', table_name='dayparts')
    op.drop_table('dayparts')
    
    op.drop_index('ix_clasificaciones_id', table_name='clasificaciones')
    op.drop_table('clasificaciones')


def downgrade() -> None:
    # Recrear tablas de catálogos (para rollback)
    op.create_table('tipos_clasificacion',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=100), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('activo', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='tipos_clasificacion_pkey')
    )
    op.create_index('ix_tipos_clasificacion_id', 'tipos_clasificacion', ['id'], unique=False)
    
    op.create_table('sellos_discograficos',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('activo', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='sellos_discograficos_pkey')
    )
    op.create_index('ix_sellos_discograficos_id', 'sellos_discograficos', ['id'], unique=False)
    
    op.create_table('personas',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('apellido', sa.VARCHAR(length=200), autoincrement=False, nullable=True),
        sa.Column('email', sa.VARCHAR(length=255), autoincrement=False, nullable=True),
        sa.Column('telefono', sa.VARCHAR(length=20), autoincrement=False, nullable=True),
        sa.Column('activa', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='personas_pkey')
    )
    op.create_index('ix_personas_id', 'personas', ['id'], unique=False)
    
    op.create_table('interpretes',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=200), autoincrement=False, nullable=False),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('activo', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='interpretes_pkey')
    )
    op.create_index('ix_interpretes_id', 'interpretes', ['id'], unique=False)
    
    op.create_table('dayparts',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=100), autoincrement=False, nullable=False),
        sa.Column('hora_inicio', sa.VARCHAR(length=5), autoincrement=False, nullable=True),
        sa.Column('hora_fin', sa.VARCHAR(length=5), autoincrement=False, nullable=True),
        sa.Column('activo', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='dayparts_pkey')
    )
    op.create_index('ix_dayparts_id', 'dayparts', ['id'], unique=False)
    
    op.create_table('clasificaciones',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('nombre', sa.VARCHAR(length=100), autoincrement=False, nullable=False),
        sa.Column('tipo_id', sa.INTEGER(), autoincrement=False, nullable=True),
        sa.Column('descripcion', sa.TEXT(), autoincrement=False, nullable=True),
        sa.Column('activa', sa.BOOLEAN(), autoincrement=False, nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), autoincrement=False, nullable=True),
        sa.PrimaryKeyConstraint('id', name='clasificaciones_pkey')
    )
    op.create_index('ix_clasificaciones_id', 'clasificaciones', ['id'], unique=False)
