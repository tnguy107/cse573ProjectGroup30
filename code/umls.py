import requests
import pandas as pd
import ast
import sys


class UMLSFunc:
    def __init__(self, new_key, api_key):
        self.new_key = new_key
        self.api_key = api_key

    def get_service_ticket(self):
        if self.new_key:
            # If using for the first time (in a while), get the TGT using a GET request, write it to a file
            DATA = {'apikey': self.api_key}
            URL = 'https://utslogin.nlm.nih.gov/cas/v1/api-key'
            r = requests.post(url=URL, data=DATA).text
            TGT = r.split('"')[3]
            with open('TGT_url.txt', 'w') as f:
                f.write(TGT)
        else:
            # Otherwise, use the TGT in the file
            with open('TGT_url.txt', 'r') as f:
                TGT = f.read()

        # A new service ticket needs to be generated every time you use a service
        DATA = {'service': 'http://umlsks.nlm.nih.gov'}
        ST = requests.post(url=TGT, data=DATA).text

        return ST

    def term_search(self, term):
        """
        :param term: search term (string)
        :return: json object with info of the top 5 results
        """
        service_ticket = self.get_service_ticket()
        URL = 'https://uts-ws.nlm.nih.gov/rest/search/current?string={}&ticket={}'.format(term, service_ticket)
        result = requests.get(url=URL).json()
        self.check_for_errors(result)
        # Get the top n results
        top_results = result['result']['results'][:10]
        return top_results

    def cui_search(self, cui):
        """
        :param cui: CUI of a term (can be collected from term_search)
        :return: json object containing info of the top 5 related terms
        """
        service_ticket = self.get_service_ticket()
        URL = 'https://uts-ws.nlm.nih.gov/rest/content/current/CUI/{}/relations?ticket={}'.format(cui, service_ticket)
        result = requests.get(url=URL).json()
        self.check_for_errors(result)
        # Get the top n results
        top_results = result['result'][:10]
        return top_results

    def check_for_errors(self, result):
        """
        :param result: json result of a UMLS function
        :return: if there is an error (probably because ticket expired), quit the program
        """
        if 'error' in result.keys():
            sys.exit('\nError: {}'.format(result['error']))

    def run_functions(self):
        """
        :return: print the results of the functions (may change to return instead)
        """
        ##############################################
        # Collect terms of interest from scraped data
        ##############################################
        scraped_terms = []
        scraped_data = pd.read_csv('HUNFLAIR_disease_predictions.tsv', sep='\t')
        for i in range(len(scraped_data)):
            entities = scraped_data.iloc[i]['entities']
            if entities == '-':
                continue
            else:
                ent_str = ast.literal_eval(entities)
                for e in ent_str:
                    if 'Labels: Disease' in e:
                        scraped_terms.append(e.split('"')[1])

        scraped_terms = list(set(scraped_terms))
        scraped_terms.sort()

        print('\nDisease-related terms found in scraped data: \n{}'.format(scraped_terms))

        ##############################################
        # Function 1: Search by term
        ##############################################
        term = scraped_terms[5]
        search_results = self.term_search(term)

        # Get the necessary values from each of the top results
        print('\nUsing search term: {}'.format(term))
        print('\nUMLS search, top results:')
        for result in search_results:
            print(result['ui'], result['name'])

        ##############################################
        # Function 2: Find related terms
        ##############################################
        related_results = self.cui_search(search_results[0]['ui'])

        print('\nRelated term search, top results for first UMLS search result:')
        for result in related_results:
            print(result['relatedId'].split('/')[-1], result['relatedIdName'])


# Insert API key from UMLS profile
api_key = 'Api key here'
# Set new_key to True if you are using for the first time and/or getting an error
new_key = True

umls = UMLSFunc(new_key=new_key, api_key=api_key)
umls.run_functions()
