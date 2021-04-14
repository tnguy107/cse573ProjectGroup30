from flask_cors import CORS

from flask import Flask, request, redirect, jsonify, render_template, make_response
import os
import json

from search_requests import query, default_query
from urllib.parse import quote_plus

app = Flask(__name__, static_folder='./static')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['TEMPLATES_AUTO_RELOAD'] = True
CORS(app)
PORT = 8080

articles = json.load(open('articles.json', 'r'))

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/search/')
def search_articles():
    if request.args['searchTerm']:
        search_term = request.args['searchTerm'].strip()
        filters = request.args['selectedFilters'].strip()
        print("search term", search_term, "filters", filters)
        results = query(term=search_term)
    else:
        results = default_query()

    for i in range(len(results)):
        results[i] = results[i][0]
    final_result = {'articles': results}

    return final_result


if __name__ == "__main__":
    app.run(port=PORT)
