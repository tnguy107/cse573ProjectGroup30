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
from pyvis.network import Network


class searchNetwork():

    def __init__(self):
        df = pd.read_csv('all_terms_metamap_categories.csv')
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

            # nx.draw(G, node_size=40)

    def create_edges(self, input):
        nt = Network(height='100%', width='100%', )
        # input keywords in input
        # No results for "cough"
        # input = ["Coughing"]
        for i in [input]:
            try:
                #print(nx.node_connected_component(self.G, i))
                connected = nx.node_connected_component(self.G, i)
                c = nx.edges(self.G, i)
                self.H.add_edges_from(c)
            except KeyError:
                print("No results")
                connected = ''

        if connected:
            #nx.draw(H, node_size=40)
            #print(self.H.nodes())
            nt.from_nx(self.H, default_node_size=10)
            # Set hover text, remove labels
            for node in nt.nodes:
                # Title is printed on hover (need to add), label is printed without hover (need to remove)
                node['title'] = node['label']
                node.pop('label', None)
                name = node['title']
                node['type'] = self.G.nodes[name]['type']
                # Assign color based on type of term
                if node['type'] == 'symptom':
                    node['color'] = '#85dcff'
                elif node['type'] == 'treatment':
                    node['color'] = '#9ef78b'
                elif node['type'] == 'drug':
                    node['color'] = '#f7f781'
                elif node['type'] == 'bodypart':
                    node['color'] = '#ffc2c2'
            
	    # nt.show_buttons()
	    # Use a low max-velocity so the graph doesn't move around too much
            nt.set_options("""
            var options = {
            "nodes": {
                "borderWidth": 1.5
            },
            "edges": {
              "color": {
                "inherit": false,
                "opacity": 0.75
            },
                "smooth": false
              },
              "physics": {
                "maxVelocity": 1,
                "minVelocity": 0.2
              }
            }
            """)
            nt.show('nx.html')

        return list(connected)

    def clear_edges(self):
        self.H = nx.Graph()
