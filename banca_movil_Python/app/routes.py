from flask import Blueprint, request, jsonify
from .db import db
from .models import User, Card, Payment, Transaction, Notification
from .logs import mongo

blueprint = Blueprint("api", __name__)

@blueprint.route("/users", methods=["POST"])
def create_user():
    data = request.json
    user = User(name=data["name"], email=data["email"], password=data["password"])
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "Usuario creado", "user_id": user.id})

@blueprint.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "Usuario no encontrado"}), 404
    return jsonify({"id": user.id, "name": user.name, "email": user.email})

@blueprint.route("/cards", methods=["POST"])
def add_card():
    data = request.json
    card = Card(user_id=data["user_id"], card_number=data["card_number"])
    db.session.add(card)
    db.session.commit()
    return jsonify({"message": "Tarjeta agregada", "card_id": card.id})

@blueprint.route("/payments", methods=["POST"])
def process_payment():
    data = request.json
    payment = Payment(user_id=data["user_id"], amount=data["amount"])
    db.session.add(payment)
    db.session.commit()

    mongo.db.transactions.insert_one({
        "user_id": data["user_id"],
        "amount": data["amount"],
        "status": "processed"
    })

    return jsonify({"message": "Pago procesado", "payment_id": payment.id})

@blueprint.route("/transactions", methods=["GET"])
def get_transactions():
    transactions = mongo.db.transactions.find()
    transactions_list = [{"user_id": t["user_id"], "amount": t["amount"], "status": t["status"]} for t in transactions]
    return jsonify(transactions_list)

@blueprint.route("/notifications", methods=["POST"])
def send_notification():
    data = request.json
    notification = Notification(user_id=data["user_id"], message=data["message"])
    db.session.add(notification)
    db.session.commit()
    return jsonify({"message": "Notificación enviada"})
