from flask_cors import CORS

from flask import Flask, request, redirect, jsonify, render_template, make_response
import os
import json

from search_requests import query
from urllib.parse import quote_plus

#app = Flask(__name__)
app = Flask(__name__, static_folder='./static')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['TEMPLATES_AUTO_RELOAD'] = True
CORS(app)
PORT = 8080

articles = json.load(open('articles.json', 'r'))

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/logistic-sample/', methods=['GET'])
def logistic_regression_sample():
    text = request.args['text'].strip()
    return text

@app.route('/article-data/', methods=['GET'])
def get_articles():
    #data = jsonify(articles)
    return make_response({"response": '+result+'})

@app.route('/query/', methods=['GET'])
def send_queries():
    query_parameters = request.args
    id = query_parameters.get('searchTerm')
    published = query_parameters.get('selectedFilters')
    print(id)
    term = quote_plus(input('Enter search term: '))
    query(term)

if __name__ == "__main__":
    app.run(port=PORT)
