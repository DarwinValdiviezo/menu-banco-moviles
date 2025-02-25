import os

class Config:
    SQLALCHEMY_DATABASE_URI = "postgresql://root:rootpassword@localhost:5432/banco"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    MONGO_URI = "mongodb://localhost:27017/banca_movil_logs"
    SECRET_KEY = "supersecretkey"
