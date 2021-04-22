#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 19 12:46:52 2021
@author: aranyak
"""

import networkx as nx
from itertools import combinations
import pandas as pd
import ast
import random
from pyvis.network import Network


class searchNetwork():

    def __init__(self):
        df = pd.read_csv('all_terms_metamap_categories_lowercase.csv')
        symptoms = [ast.literal_eval(term_list) for term_list in df['symptoms']]
        treatments = [ast.literal_eval(term_list) for term_list in df['treatments']]
        drugs = [ast.literal_eval(term_list) for term_list in df['drugs']]
        bodyparts = [ast.literal_eval(term_list) for term_list in df['bodyparts']]

        a = [s+t+d+b for s, t, d, b in zip(symptoms, treatments, drugs, bodyparts)]
        # a=[["cough","foot","brain"],
        #    ["pain","fever","brain"]]

        # creating the graph
        self.G = nx.Graph()
        self.H = nx.Graph()
        self.nt = Network(height='100%', width='100%', )
        self.nt.set_options("""
        var options = {
          "edges": {
            "color": {
              "inherit": "both",
              "opacity": 0.75
            },
            "smooth": false
          },
          "physics": {
            "maxVelocity": 2,
            "minVelocity": 0.2,
            "solver": "forceAtlas2Based"
          }
        }
        """)

        for i in range(len(symptoms)):
            for j in range(len(symptoms[i])):
                self.G.add_nodes_from([(symptoms[i][j], {'type': 'symptom'})])
            for j in range(len(treatments[i])):
                self.G.add_nodes_from([(treatments[i][j], {'type': 'treatment'})])
            for j in range(len(drugs[i])):
                self.G.add_nodes_from([(drugs[i][j], {'type': 'drug'})])
            for j in range(len(bodyparts[i])):
                self.G.add_nodes_from([(bodyparts[i][j], {'type': 'bodypart'})])
            comb = combinations(a[i], 2)
            b = []
            for j in list(comb):
                b.append(j)
            self.G.add_edges_from(b)

        #nx.draw(self.G, node_size=40)

    def create_edges(self, search_terms):
        # input keywords in input
        # No results for "cough"
        #inputs = ["slight fever", "Vertigo", "Gingival Diseases", "Renal carnitine transport defect", "Arthralgia"]

        inputs = list(set(search_terms))
        inputs = [i.lower() for i in inputs]
        connected = ''
        for i in inputs:
            try:
                #print(nx.node_connected_component(self.G, input))
                connected = nx.node_connected_component(self.G, i)
                c = nx.edges(self.G, i)
                self.H.add_edges_from(c)
            except KeyError:
                print("No results")

        # dict = {}
        # for i in inputs:
        #     dict[i] = self.H.degree(i)

        node_degrees = {}
        for node in self.G.nodes:
            degrees = self.H.degree(node)
            if type(degrees) == int and degrees > 0:  # can change to 1 or more
                node_degrees[node] = degrees

        if connected:
            #nx.draw(H, node_size=40)
            #print(self.H.nodes())
            self.nt.from_nx(self.H, default_node_size=15)
            # Set hover text, remove labels
            for node in self.nt.nodes:
                # Title is printed on hover (need to add), label is printed without hover (need to remove)
                if 'label' in node.keys():
                    node['title'] = node['label']
                    node.pop('label', None)
                    name = node['title']
                    node['type'] = self.G.nodes[name]['type']

                # Assign color based on type of term and darken nodes based on number of degrees
                # Don't darken nodes that are search terms, otherwise they will become black
                if node['title'] not in inputs:
                    num_degrees = node_degrees[node['title']]
                else:
                    node['borderWidth'] = 2
                    num_degrees = 1

                if node['type'] == 'symptom':
                    blue = '#72c1e0'
                    node['color'] = color_variant(blue, -75*(num_degrees-2))  # first number is multiplier (rate of darkening), second is the starting shade (higher=brighter)
                elif node['type'] == 'treatment':
                    green = '#9ef78b'
                    node['color'] = color_variant(green, -75*(num_degrees-2))
                elif node['type'] == 'drug':
                    yellow = '#7fcf6d'
                    node['color'] = color_variant(yellow, -75*(num_degrees-2))
                elif node['type'] == 'bodypart':
                    red = '#e09b9b'
                    node['color'] = color_variant(red, -75*(num_degrees-2))
                if num_degrees > 1:
                    print(node['title'])
                # else:
                #     #node['color'] = '#d6d6d6'


        #return list(connected)

        # Create a set of filter terms based on number of degrees
        symptom_filters = []
        treatment_filters = []
        bodypart_filters = []
        drug_filters = []

        for node in self.nt.nodes:
            term_name = node['title']
            term_type = node['type']
            # Only return terms that are related to ALL of the search terms (may change in future)
            # Only take the first 5 terms for each category
            if node_degrees[term_name] == len(search_terms) and term_name not in search_terms:
                if term_type == 'symptom':
                    symptom_filters.append(term_name)
                elif term_type == 'treatment':
                    treatment_filters.append(term_name)
                elif term_type == 'bodypart':
                    bodypart_filters.append(term_name)
                elif term_type == 'drug':
                    drug_filters.append(term_name)

        random.shuffle(symptom_filters)
        random.shuffle(treatment_filters)
        random.shuffle(bodypart_filters)
        random.shuffle(drug_filters)
        filter_terms = [{'title': 'Treatments', 'filterItems': treatment_filters[:5]}, {'title': 'Symptoms', 'filterItems': symptom_filters[:5]}, {'title': 'Body Parts', 'filterItems': bodypart_filters[:5]}]

        return filter_terms

    def show_network(self):
        # Use a low max-velocity so the graph doesn't move around too much
        # nt.show_buttons()

        self.nt.show('nx.html')

    def clear_edges(self):
        self.H = nx.Graph()


# Copied from: https://chase-seibert.github.io/blog/2011/07/29/python-calculate-lighterdarker-rgb-colors.html
def color_variant(hex_color, brightness_offset=1):
    """ takes a color like #87c95f and produces a lighter or darker variant """
    if len(hex_color) != 7:
        raise Exception("Passed %s into color_variant(), needs to be in #87c95f format." % hex_color)
    rgb_hex = [hex_color[x:x+2] for x in [1, 3, 5]]
    new_rgb_int = [int(hex_value, 16) + brightness_offset for hex_value in rgb_hex]
    new_rgb_int = [min([255, max([0, i])]) for i in new_rgb_int] # make sure new values are between 0 and 255
    # hex() produces "0x88", we want just "88"
    return "#" + "".join([hex(i)[2:] for i in new_rgb_int])
