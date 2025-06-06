import os
from flask import Flask, jsonify
from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_talisman import Talisman
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# ...existing code...

# Test comment for PR workflow

# ...existing code...

def create_app():
    app = Flask(__name__)
    
    # Configure security headers
    Talisman(app,
        force_https=False,  # Allow HTTP for health checks
        strict_transport_security=False,  # Disable HSTS for HTTP
        session_cookie_secure=False,  # Allow non-secure cookies for HTTP
        content_security_policy={
            'default-src': "'self'",
            'img-src': "'self' data: https:",
            'script-src': "'self' 'unsafe-inline' 'unsafe-eval'",
            'style-src': "'self' 'unsafe-inline'",
        }
    )

    # Configure CORS
    CORS(app, resources={
        r"/*": {
            "origins": os.getenv('ALLOWED_ORIGINS', '*').split(','),
            "methods": ["GET", "POST", "OPTIONS"],
            "allow_headers": ["Content-Type"]
        }
    })

    # Configure rate limiting
    limiter = Limiter(
        app=app,
        key_func=get_remote_address,
        default_limits=["200 per day", "50 per hour"]
    )

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    @app.route("/")
    @limiter.limit("5 per minute")
    def hello():
        return jsonify({"message": "Hello, World"})

    @app.route("/health")
    def health_check():
        return jsonify({
            "status": "healthy",
            "version": os.getenv('APP_VERSION', '1.0.0')
        })

    return app
