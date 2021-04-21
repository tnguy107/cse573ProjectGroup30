from flask_cors import CORS

from flask import Flask, request, redirect, jsonify, render_template, make_response
import os
import json

from search_requests import query, default_query, filter_query
from urllib.parse import quote_plus

import UMLSFunc

app = Flask(__name__, static_folder='./static')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['TEMPLATES_AUTO_RELOAD'] = True
CORS(app)
PORT = 8080

#articles = json.load(open('articles.json', 'r'))

@app.route('/')
def hello_world():
    return render_template('index.html')
@app.route('/umls/')
def umls_parser():
    uml = UMLSFunc.UMLSFunc(True, '33576640-d3f7-4520-a856-c4ebc92ef62b')
    uml.get_service_ticket()
    uml.run_functions("coughing")
    

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
    
    final_result = {'articles': results, 'filters' : [{"title": "Medications", "filterItems": ["Med1", "Med2", "Med3", "Med4"] }, { "title": "Symptoms", "filterItems": ["Fever", "Cough", "Body Pain", "Headache"]}]}
    return final_result


@app.route('/filter/')
def filter_articles():
    if request.args['searchTerm']: 
        search_term = request.args['searchTerm'].strip()
        filters = request.args['selectedFilters'].strip()
        print("Filter section: search term", search_term, "filters", filters)
        results = filter_query(term=search_term, filter_terms=filters)
    else:
        results = default_query()

    for i in range(len(results)):
        results[i] = results[i][0]
    
    final_result = {'articles': results, 'filters' : [{"title": "Medications", "filterItems": ["Med1", "Med2", "Med3", "Med4"] }, { "title": "Symptoms", "filterItems": ["Fever", "Cough", "Body Pain", "Headache"]}]}
    return final_result


if __name__ == "__main__":
    #umls_parser()
    app.run(port=PORT)
