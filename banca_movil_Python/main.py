from flask import Flask
from app.routes import blueprint
from app.db import init_db
from app.logs import init_mongo

app = Flask(__name__)
app.config.from_object("config.Config")

# Inicializar bases de datos
init_db(app)
init_mongo(app)

# Registrar rutas
app.register_blueprint(blueprint)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
