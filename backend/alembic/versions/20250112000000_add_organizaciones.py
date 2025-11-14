"""add_organizaciones

Revision ID: 20250112000000
Revises: 20250108000000
Create Date: 2025-01-12 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '20250112000000'
down_revision = '20250108000000'
branch_labels = None
depends_on = None


def upgrade():
    # Crear tabla de organizaciones
    op.create_table(
        'organizaciones',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('nombre', sa.String(length=255), nullable=False),
        sa.Column('nombre_empresa', sa.String(length=255), nullable=True, comment='Nombre de la empresa/organización'),
        sa.Column('telefono', sa.String(length=50), nullable=True, comment='Teléfono de contacto'),
        sa.Column('direccion', sa.String(length=500), nullable=True, comment='Dirección'),
        sa.Column('ciudad', sa.String(length=100), nullable=True, comment='Ciudad'),
        sa.Column('activa', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=True),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index('ix_organizaciones_id', 'organizaciones', ['id'], unique=False)
    
    # Crear organización por defecto para datos existentes
    op.execute("""
        INSERT INTO organizaciones (nombre, activa) 
        VALUES ('Organización Default', true)
    """)
    
    # Obtener el ID de la organización default
    default_org_id = op.get_bind().execute(sa.text("SELECT id FROM organizaciones WHERE nombre = 'Organización Default' LIMIT 1")).scalar()
    
    # Agregar organizacion_id a usuarios (nullable primero para migrar datos)
    op.add_column('usuarios', sa.Column('organizacion_id', sa.Integer(), nullable=True))
    op.create_index('ix_usuarios_organizacion_id', 'usuarios', ['organizacion_id'], unique=False)
    op.create_foreign_key('fk_usuarios_organizacion', 'usuarios', 'organizaciones', ['organizacion_id'], ['id'], ondelete='CASCADE')
    
    # Asignar todos los usuarios existentes a la organización default
    if default_org_id:
        op.execute(f"UPDATE usuarios SET organizacion_id = {default_org_id} WHERE organizacion_id IS NULL")
    
    # Hacer organizacion_id NOT NULL después de migrar
    op.alter_column('usuarios', 'organizacion_id', nullable=False)
    
    # Agregar organizacion_id a difusoras
    op.add_column('difusoras', sa.Column('organizacion_id', sa.Integer(), nullable=True))
    op.create_index('ix_difusoras_organizacion_id', 'difusoras', ['organizacion_id'], unique=False)
    op.create_foreign_key('fk_difusoras_organizacion', 'difusoras', 'organizaciones', ['organizacion_id'], ['id'], ondelete='CASCADE')
    
    # Asignar todas las difusoras existentes a la organización default
    if default_org_id:
        op.execute(f"UPDATE difusoras SET organizacion_id = {default_org_id} WHERE organizacion_id IS NULL")
    
    # Hacer organizacion_id NOT NULL después de migrar
    op.alter_column('difusoras', 'organizacion_id', nullable=False)
    
    # Agregar organizacion_id a cortes
    op.add_column('cortes', sa.Column('organizacion_id', sa.Integer(), nullable=True))
    op.create_index('ix_cortes_organizacion_id', 'cortes', ['organizacion_id'], unique=False)
    op.create_foreign_key('fk_cortes_organizacion', 'cortes', 'organizaciones', ['organizacion_id'], ['id'], ondelete='CASCADE')
    
    # Asignar todos los cortes existentes a la organización default
    if default_org_id:
        op.execute(f"UPDATE cortes SET organizacion_id = {default_org_id} WHERE organizacion_id IS NULL")
    
    # Hacer organizacion_id NOT NULL después de migrar
    op.alter_column('cortes', 'organizacion_id', nullable=False)


def downgrade():
    # Eliminar foreign keys e índices
    op.drop_constraint('fk_cortes_organizacion', 'cortes', type_='foreignkey')
    op.drop_index('ix_cortes_organizacion_id', table_name='cortes')
    op.drop_column('cortes', 'organizacion_id')
    
    op.drop_constraint('fk_difusoras_organizacion', 'difusoras', type_='foreignkey')
    op.drop_index('ix_difusoras_organizacion_id', table_name='difusoras')
    op.drop_column('difusoras', 'organizacion_id')
    
    op.drop_constraint('fk_usuarios_organizacion', 'usuarios', type_='foreignkey')
    op.drop_index('ix_usuarios_organizacion_id', table_name='usuarios')
    op.drop_column('usuarios', 'organizacion_id')
    
    # Eliminar tabla de organizaciones
    op.drop_index('ix_organizaciones_id', table_name='organizaciones')
    op.drop_table('organizaciones')

