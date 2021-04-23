from selenium import webdriver
import json

# for Scrapping and appending to "discussions" object
def moddaloScrapping(discussions):
    reply_anss = driver.find_elements_by_class_name("post-content-container")
    indent_subreply_anss = driver.find_elements_by_class_name("indent")
    discussion = {}
    discussion["url"] = ""
    discussion["title"] = ""
    discussion["author"] = ""
    discussion["content"] = ""
    discussion["replies"] = []
    use_replies = []
    for j in range(len(reply_anss)):
        if j == 0:
            # get content
            reply_str = str(reply_anss[j].text.encode('utf-8').decode('ascii', 'ignore'))
            reply_str = reply_str.replace("\n", " ")
            reply_str = reply_str.replace("Permalink", " ")
            reply_str = reply_str.replace("Show parent", " ")
            discussion["content"] = reply_str

            # get title
            title_of_content = driver.find_element_by_tag_name('h3')
            title_of_content = title_of_content.text.encode('utf-8').decode('ascii', 'ignore')
            title_of_content = title_of_content.replace("\n", "")
            discussion["title"] = title_of_content

            # get author
            author = driver.find_element_by_xpath("/html/body/div[4]/div[1]/div[2]/section/div/div/article/div[1]/div/header/div[2]/address/a")
            author = author.text.encode('utf-8').decode('ascii', 'ignore')
            author = author.replace("\n", "")
            discussion["author"] = author

            # get URL
            url_str = driver.current_url
            discussion["url"] = str(url_str)
        else:
            reply_str = str(reply_anss[j].text.encode('utf-8').decode('ascii', 'ignore'))
            reply_str = reply_str.replace("\n", " ")
            reply_str = reply_str.replace("Permalink", " ")
            reply_str = reply_str.replace("Show parent", " ")

            sub_replies_str = str(indent_subreply_anss[j].text.encode('utf-8').decode('ascii', 'ignore'))
            sub_replies_str = sub_replies_str.replace("\n", " ")
            sub_replies_str = sub_replies_str.replace("Permalink", " ")
            sub_replies_str = sub_replies_str.replace("Show parent", " ")
            reply = {}
            reply["reply_content"] = reply_str
            reply["sub_reply_content"] = sub_replies_str
            use_replies = []
            use_replies.append(reply)
            discussion["replies"].append(use_replies)
    discussions.append(discussion)
    return discussions

# driver code
url='https://covid19.camhx.ca/mod/forum/view.php?id=1'
driver = webdriver.Chrome()
driver.get(url)
driver.find_element_by_xpath("/html/body/div[4]/div[1]/div[2]/section/div/div[2]/table/tbody/tr[51]/th/div/a").click()
discussions=[]


for i in range(51):
    if i==0:
        discussions=moddaloScrapping(discussions)
        driver.find_element_by_xpath("/html/body/div[4]/div[1]/div[2]/section/div/div/div[4]/ul/li/a").click()
    else:
        discussion=moddaloScrapping(discussions)
        if i<=49:
            driver.find_element_by_xpath("/html/body/div[4]/div[1]/div[2]/section/div/div/div[4]/ul/li[2]/a").click()


out_file = open("patient_info.json", "w")
json.dump(discussions, out_file, indent = 2)
out_file.close()


