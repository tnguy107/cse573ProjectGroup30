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

@app.route('/search/', methods=['GET'])
def search_articles():
    #data = jsonify(articles)
    #return make_response({"response": '+result+'})
    search_term = request.args['searchTerm'].strip()
    filters = request.args['selectedFilters'].strip()
    print("search term", search_term, "filters", filters)
    results = query(term=search_term)
    return results

if __name__ == "__main__":
    app.run(port=PORT)
