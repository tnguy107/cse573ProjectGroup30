function http_request(param, callback) {
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	       // Typical action to be performed when the document is ready:
	       console.log('Fetched ' + param + '...')
	       callback(xhttp.responseText);
	    }
	};
	xhttp.open("GET", "http://localhost:8080/logistic-sample/?text="+param, true);
	xhttp.send(); 	
}


function display_result(result) {
  console.log('Classified as: ' + result);
  document.getElementById('result_container').innerHTML = result;
}

function call_logistic_regression() {
  var term = (document.getElementById('input-box').value);
  http_request(term, display_result)
  
}
