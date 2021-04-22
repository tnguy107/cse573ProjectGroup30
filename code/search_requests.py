from urllib.request import urlopen
from urllib.parse import quote_plus
import json
import ast
import random
# TODO: We could use truecase to try put the text back into original casing since everything is lowercase currently
#import truecase

def default_query():
    # Some default articles to show when the user first opens the page or submits a search with no search term
    # Get n articles from each site and randomize the order
    post_url = []
    for site in ['medhelp', 'camhx', 'livescience', 'mayoclinic', 'patient.info']:
        with urlopen('http://localhost:8983/solr/allData/select?q=url%3A*{}*&rows=5'.format(site)) as u:  # return upto 10 results by default
            result = json.loads(u.read().decode())
        for res in result['response']['docs']:
            post_url.append(res['url'][0])

    random.shuffle(post_url)

    #######################################################################
    # Query 3: Get the content, replies, and subreplies of a group of posts
    #######################################################################
    unique_url = list(set(post_url))
    final_results_all = []
    for url in unique_url:
        with urlopen('http://localhost:8983/solr/allData/select?q=url%3A%22{}%22'.format(url)) as u:  # return upto 10 results by default
            result3 = json.loads(u.read().decode())

        final_results = []
        for res in result3['response']['docs']:
            title = res['title'][0]
            if 'author' in res.keys():
                author = res['author'][0]
            else:
                author = 'unknown'
            content = res['content'][0]
            replies = res['replies'][0]
            replies_list = ast.literal_eval(replies)

            final_results.append(
                {'title': title, 'author': author, 'url': url, 'content': content, 'replies': replies_list})

        # Format of final_results_all: [{title1, author1, url1, content1, replies1}, {title2, author2, url2, content2, replies2}, ...]
        # 'replies' format: {'content', 'sub_replies}
        final_results_all.append(final_results)

    return final_results_all


def query(term):
    runLoop = True
    while runLoop:

        # Uncomment to only run once
        runLoop = False

        #term = quote_plus(input('Enter search term: '))

        #######################################################################
        # Query 1: Search for a term across all posts
        #######################################################################
        # uncomment next line to return up to 800 results
        # with urlopen('http://localhost:8983/solr/metamapData/select?q={}&rows=800'.format(term)) as url: 
        with urlopen('http://localhost:8983/solr/metamapData/select?q=SymptomName%3A{0}%20OR%20TreatmentName%3A{0}%20OR%20DrugName%3A{0}%20OR%20BodypartName%3A{0}&rows=50'.format(quote_plus(term))) as u: #return upto 10 results by default
           result1 = json.loads(u.read().decode())
        # with urlopen('http://localhost:8983/solr/metamapData/select?q={}'.format(quote_plus(term))) as u: #return upto 10 results by default
        #     result1 = json.loads(u.read().decode())


        # post_num is the list of post numbers (used for Query 2)
        post_num = []
        # post_url is the list of urls (used for Query 3)
        post_url = []
        for res in result1['response']['docs']:
            post_num.append(res['PostNumber'][0])
            post_url.append(res['PostLink'][0])

        if not post_num:
            print("No results.\n")
            # Sid: instead of "continue" (not needed if not looping), return a "no results" object
            #continue
            return [[{'title': 'No results', 'author': '', 'url': '', 'content': '', 'replies': ''}]]


        # post_info format: [(post_num1, post_url2), (post_num2, post_url2), ...]
        post_info = list(zip(post_num, post_url))

        #######################################################################
        # Query 2: Get all symptoms/treatments/body parts from a group of posts
        #######################################################################
        unique_num = list(set(post_num))
        symptom_list = []
        treatment_list = []
        drug_list = []
        bodypart_list = []
        for num in unique_num:
            #return upto 10 results by default
            with urlopen('http://localhost:8983/solr/metamapData/select?q=PostNumber%3A{}'.format(num)) as u:
                result2 = json.loads(u.read().decode())

            for res in result2['response']['docs']:
                if 'SymptomName' in res.keys():
                    symptom_list.append(res['SymptomName'][0])
                elif 'TreatmentName' in res.keys():
                    treatment_list.append(res['TreatmentName'][0])
                elif 'DrugName' in res.keys():
                    drug_list.append(res['DrugName'][0])
                elif 'BodypartName' in res.keys():
                    bodypart_list.append(res['BodypartName'][0])

        print("\nList of related symptom : {}".format(symptom_list))
        print("List of related treatment: {}".format(treatment_list))
        print("List of related drug: {}".format(drug_list))
        print("List of related body part: {}".format(bodypart_list))
        print("\n\n\n")

        #######################################################################
        # Query 3: Get the content, replies, and subreplies of a group of posts
        #######################################################################
        unique_url = list(set(post_url))
        final_results_all = []
        for url in unique_url:
            with urlopen('http://localhost:8983/solr/allData/select?q=url%3A%22{}%22&rows=15'.format(url)) as u: #return upto 10 results by default
                result3 = json.loads(u.read().decode())
        
            final_results = []
            for res in result3['response']['docs']:
                title = res['title'][0]
                if 'author' in res.keys():
                    author = res['author'][0]
                else:
                    author = 'unknown'
                content = res['content'][0]
                replies = res['replies'][0]
                replies_list = ast.literal_eval(replies)
                
                final_results.append({'title': title, 'author': author, 'url': url, 'content': content, 'replies': replies_list})
                
            # Format of final_results_all: [{title1, author1, url1, content1, replies1}, {title2, author2, url2, content2, replies2}, ...]
            # 'replies' format: {'content', 'sub_replies}
            final_results_all.append(final_results)   


        # # print out final result
        # for url_res in final_results_all:
        #     for res in url_res:
        #         title = res['title']
        #         author = res['author']
        #         url = res['url']
        #         content = res['content']
        #         replies = res['replies']
        #         print("Title: {}".format(title))
        #         print("Author: {}".format(author))
        #         print("Url: {}".format(url))
        #         print("Content: {}".format(content))
        #         for reply in replies:
        #             print("\tReply: {}".format(reply['content']) )
        #             for subreply in reply['sub_replies']:
        #                 if subreply != '':
        #                     print("\t\tSubreply: {}".format(subreply))
        #         print("\n")
        #     print('\n------------------------------------------------------------------------')

        # return final_results_all

        # dict to sort results (len, post)
        sorted_results = {}
        for post in final_results_all:
            sorted_results[len(post[0]['replies'])] = post
        # for i in range(len(final_results_all)):
        #     print("replies: " + final_results_all[i]["replies"])

        # list of post in sorted order
        final_sorted_results = []
        for i in reversed(sorted(sorted_results.keys())):
            final_sorted_results.append(sorted_results[i])

        print(len(final_sorted_results))
        return final_sorted_results


def filter_query(term, filter_terms):
    if filter_terms == '':
        return default_query()
    print("start filter_query: \n")
    #######################################################################
    # Query 1: Search for a term across all posts
    #######################################################################
    # uncomment next line to return up to 800 results
    # with urlopen('http://localhost:8983/solr/metamapData/select?q={}&rows=800'.format(term)) as url:
    with urlopen('http://localhost:8983/solr/metamapData/select?q=SymptomName%3A{0}%20OR%20TreatmentName%3A{0}%20OR%20DrugName%3A{0}%20OR%20BodypartName%3A{0}'.format(
            term)) as u:  # return upto 10 results by default
        result1 = json.loads(u.read().decode())

    # post_url is the list of urls (used for Query 3)
    post_url = []
    for res in result1['response']['docs']:
        post_url.append(res['PostLink'][0])

    # if no results, return no results
    if not post_url:
        print("No results.\n")
        return [[{'title': 'No results', 'author': '', 'url': '', 'content': '', 'replies': ''}]]

    print("url before filter: " + '\n'.join(list(set(post_url))))
    # for each url in list, if no filter terms exists, remove url
    for url in list(set(post_url)):
        # old = (':','/')
        # new = ("%3A",'%2F')
        # for x, y in zip(old, new):
        processed_url = url.replace(':', '%3A').replace('/', '%2F')
        # term = filter_terms[0]
        all_filter_term = '('
        print(' '.join(filter_terms))
        for term in filter_terms.split(','):
            print("\nAll filter terms before add: " + all_filter_term)
            all_filter_term += term.replace(' ', '%20+') + '+'
            print("\nAll filter terms after add: " + all_filter_term)
        all_filter_term += ')'
        print(all_filter_term)
        # with urlopen('http://localhost:8983/solr/metamapData/select?q=%2B{}%20%2B%22{}%22'.format(term, processed_url)) as u:
        with urlopen('http://localhost:8983/solr/metamapData/select?q=(SymptomName%3A{0}%20OR%20TreatmentName%3A{0}%20OR%20DrugName%3A{0}%20OR%20BodypartName%3A{0})%20AND%20(PostLink:%22{1}%22)'.format(all_filter_term,
                                                                                            processed_url)) as u:
            print("urlopen: " + 'http://localhost:8983/solr/metamapData/select?q=(SymptomName%3A{0}%20OR%20TreatmentName%3A{0}%20OR%20DrugName%3A{0}%20OR%20BodypartName%3A{0})%20AND%20(%22{1}%22)'.format(all_filter_term,
                                                                                                             processed_url))
            resultURLSearch = json.loads(u.read().decode())
            if not resultURLSearch['response']['docs']:
                post_url.remove(url)

    print("url after filter: " + '\n'.join(list(set(post_url))))
    #######################################################################
    # Query 3: Get the content, replies, and subreplies of a group of posts
    #######################################################################
    unique_url = list(set(post_url))
    final_results_all = []
    for url in unique_url:
        with urlopen('http://localhost:8983/solr/allData/select?q=url%3A%22{}%22'.format(
                url)) as u:  # return upto 10 results by default
            result3 = json.loads(u.read().decode())

        final_results = []
        for res in result3['response']['docs']:
            title = res['title'][0]
            if 'author' in res.keys():
                author = res['author'][0]
            else:
                author = 'unknown'
            content = res['content'][0]
            replies = res['replies'][0]
            replies_list = ast.literal_eval(replies)

            final_results.append(
                {'title': title, 'author': author, 'url': url, 'content': content, 'replies': replies_list})

        # Format of final_results_all: [{title1, author1, url1, content1, replies1}, {title2, author2, url2, content2, replies2}, ...]
        # 'replies' format: {'content', 'sub_replies}
        final_results_all.append(final_results)

    # dict to sort results (len, post)
    sorted_results = {}
    for post in final_results_all:
        sorted_results[len(post[0]['replies'])] = post
    # for i in range(len(final_results_all)):
    #     print("replies: " + final_results_all[i]["replies"])

    # list of post in sorted order
    final_sorted_results = []
    for i in reversed(sorted(sorted_results.keys())):
        final_sorted_results.append(sorted_results[i])

    print(len(final_sorted_results))
    return final_sorted_results


    #return final_results_all