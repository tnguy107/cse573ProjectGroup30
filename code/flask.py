from flask_cors import CORS

from flask import Flask, request, redirect, jsonify, render_template
import os

#app = Flask(__name__)
app = Flask(__name__, static_folder='./static')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['TEMPLATES_AUTO_RELOAD'] = True
CORS(app)
PORT = 8080

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/logistic-sample/', methods=['GET'])
def logistic_regression_sample():
    text = request.args['text'].strip()
    return text


if __name__ == "__main__":
    app.run(port=PORT)
