from flask import Flask, jsonify, request

server = Flask(__name__)

@server.route("/api/logs", methods=["POST"])
def process_logs():
    try:
        data = request.json  # or request.get_json()
        logs = data.get("logs", [])

        results = [{"log": l, "has_error": "ERROR" in l} for l in logs]

        return jsonify({"status": "ok", "results": results}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

if __name__ == "__main__":
    server.run(debug=True, host="0.0.0.0", port=5000)
