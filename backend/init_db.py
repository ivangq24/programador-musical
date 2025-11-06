"""
Database initialization script for production deployment
"""
import logging
from sqlalchemy import create_engine, text
from app.core.config import settings
from app.core.database import Base
from app.models import *  # Import all models

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def init_database():
    """Initialize database with tables and basic data"""
    try:
        # Create engine
        engine = create_engine(settings.database_url)
        
        # First check if tables already exist and have data
        with engine.connect() as conn:
            try:
                # Check if difusoras table exists and has data
                result = conn.execute(text("SELECT COUNT(*) FROM difusoras"))
                count = result.scalar()
                
                if count > 0:
                    logger.info(f"Database already initialized with {count} difusoras. Skipping initialization.")
                    return
                else:
                    logger.info("Difusoras table exists but is empty. Running data setup...")
                    
            except Exception as e:
                logger.info(f"Difusoras table doesn't exist or error checking: {e}")
                logger.info("Creating database tables...")
                
                # Create all tables only if they don't exist
                Base.metadata.create_all(bind=engine)
                logger.info("Database tables created successfully")
                
                # Run initial data setup
                logger.info("Running initial data setup...")
                run_initial_data_setup(conn)
                
    except Exception as e:
        logger.error(f"Database initialization failed: {str(e)}")
        # Don't raise the exception in production, just log it
        logger.error("Continuing with application startup despite database initialization error")

def run_initial_data_setup(conn):
    """Run initial data setup"""
    try:
        # Start a new transaction
        trans = conn.begin()
        
        # Create default difusora
        conn.execute(text("""
            INSERT INTO difusoras (siglas, nombre, slogan, activa) 
            VALUES ('RP', 'Radio Principal', 'Tu estación favorita', true)
            ON CONFLICT DO NOTHING
        """))
        
        # Create default categories
        categories = [
            ('Pop', 'Música Pop'),
            ('Rock', 'Música Rock'),
            ('Balada', 'Baladas'),
            ('Tropical', 'Música Tropical'),
            ('Clásica', 'Música Clásica')
        ]
        
        for name, desc in categories:
            conn.execute(text("""
                INSERT INTO categorias (nombre, descripcion, activa) 
                VALUES (:name, :desc, true)
                ON CONFLICT DO NOTHING
            """), {"name": name, "desc": desc})
        
        trans.commit()
        logger.info("Initial data setup completed")
        
    except Exception as e:
        logger.error(f"Initial data setup failed: {str(e)}")
        try:
            trans.rollback()
        except:
            pass
        raise

if __name__ == "__main__":
    init_database()