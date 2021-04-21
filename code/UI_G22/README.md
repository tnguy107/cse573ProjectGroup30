- Mock API: "https://f747eceb-c84f-4389-90bb-22783cedd28f.mock.pstmn.io/getarticles"

- The response of this api is in the following format:

	{
	    "articles": [
	        {
	            "title": "Article Title",
	            "author": "John Doe",
	            "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
	            "replies": []
	        },
	        {
	            "title": "Article Title",
	            "author": "John Doe",
	            "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
	            "replies": []
	        }
	    ],
	    "filters": [
	        {
	            "title": "Medications",
	            "filterItems": [
	                "Med1",
	                "Med2"
	            ]
	        },
	        {
	            "title": "Symptoms",
	            "filterItems": [
	                "Fever",
	                "Cough"
	            ]
	        }
	    ]
	}


- This API should be updated with the actual API and it should return the response in the same format. 

- On the initial load the data response should be as per general COVID-19 data. 
- On selecting the filters and search term, a new query will be sent to the backend and the screen will be updated with the response. 
- Additions or styling can be done on top of this basic User Interface by respective teams.
- Technologies used: HTML5, CSS3, JavaScript (ES6 version)
- No Installations required.   