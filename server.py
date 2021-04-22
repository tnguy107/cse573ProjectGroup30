from flask_cors import CORS
from flask import Flask, request, redirect, jsonify, render_template, make_response
import os
import json
from search_requests import query, default_query
from graph_generator import searchNetwork
from pyvis.network import Network
from urllib.parse import quote_plus

app = Flask(__name__, static_folder='./static')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['TEMPLATES_AUTO_RELOAD'] = True
CORS(app)
PORT = 8080

#articles = json.load(open('articles.json', 'r'))
net = searchNetwork()
search_history = []


@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/search/')
def search_articles():
    if request.args['searchTerm']:
        search_term = request.args['searchTerm'].strip()
        filters = request.args['selectedFilters'].strip()
        search_history.append(search_term)
        #print("search term", search_term, "filters", filters)
        results = query(term=search_term)
    else:
        results = default_query()

    for i in range(len(results)):
        results[i] = results[i][0]
    final_result = {'articles': results, 'filters': [ { "title": "Medications", "filterItems": ["Med1", "Med2", "Med3", "Med4"] }, { "title": "Symptoms", "filterItems": ["Fever", "Cough", "Body Pain", "Headache"] } ]}

    return final_result

@app.route('/network/')
def generate_network():
    net.clear_edges()
    if request.args['searchTerm']:
        search_term = request.args['searchTerm'].strip()
        search_history.append(search_term)
        #print("search term", search_term)
        conn_nodes = net.create_edges(search_terms=search_history)
        if conn_nodes:
            return {'results': conn_nodes}
        else:
            return {'results': 'none'}
    return {'results': ''}


if __name__ == "__main__":
    app.run(port=PORT)
