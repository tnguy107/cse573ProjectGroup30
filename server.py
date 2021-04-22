from flask_cors import CORS
from flask import Flask, request, redirect, jsonify, render_template, make_response
import os
import json
from search_requests import query, default_query, filter_query
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
curr_filters = []

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

    filter_terms = net.create_edges(search_terms=search_history)
    global curr_filters
    curr_filters = filter_terms

    final_result = {'articles': results, 'filters': filter_terms}
    #final_result = {'articles': results, 'filters': [ { "title": "Medications", "filterItems": ["Med1", "Med2", "Med3", "Med4"] }, { "title": "Symptoms", "filterItems": ["Fever", "Cough", "Body Pain", "Headache"] } ]}

    return final_result


@app.route('/network/')
def generate_network():
    # Generation was moved to search_articles above. This function only shows the graph now.
    # net.clear_edges()
    # if request.args['searchTerm']:
    #     search_term = request.args['searchTerm'].strip()
    #     search_history.append(search_term)
    #     #print("search term", search_term)
    #     conn_nodes = net.create_edges(search_terms=search_history)
    #     if conn_nodes:
    #         return {'results': conn_nodes}
    #     else:
    #         return {'results': 'none'}
    # return {'results': ''}
    net.show_network()
    return {'results': ''}


@app.route('/filter/')
def filter_articles():
    #filters = ''
    if request.args['searchTerm']:
        search_term = request.args['searchTerm'].strip()
        filters = request.args['selectedFilters'].strip()
        print("Filter section: search term", search_term, "filters", filters)
        results = filter_query(term=search_term, filter_terms=filters)
    else:
        results = default_query()

    for i in range(len(results)):
        results[i] = results[i][0]

    #final_result = {'articles': results,
    #                'filters': [{"title": "Medications", "filterItems": ["Med1", "Med2", "Med3", "Med4"]},
    #                            {"title": "Symptoms", "filterItems": ["Fever", "Cough", "Body Pain", "Headache"]}]}

    #if filters == '':
        #final_result = {'articles': results, 'filters': [{'title': 'Treatments', 'filterItems': []}, {'title': 'Symptoms', 'filterItems': []}]}
    #else:
    final_result = {'articles': results, 'filters': curr_filters}
    return final_result


if __name__ == "__main__":
    app.run(port=PORT)
