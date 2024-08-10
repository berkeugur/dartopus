document.addEventListener('DOMContentLoaded', function() {
  try {
    const routesData = JSON.parse(document.getElementById('routes-data').textContent);
    const routesContainer = document.getElementById('routes');
    const endpointSection = document.querySelector('.endpoint-section');
    const responseSection = document.getElementById('response-content');

    routesData.forEach(route => {
      const routeElement = document.createElement('li');
      routeElement.className = 'route';
      routeElement.innerHTML = `<span class="method">${route.method}</span> <span class="path">${route.path}</span>`;
      
      // Add click event to show details in the endpoint section
      routeElement.addEventListener('click', () => {
        let html = `<h2>${route.method} ${route.path}</h2>`;
        
        html += `
          <div class="ios13-segmented-control">
            <span class="selection"></span>
            <div class="option">
              <input type="radio" id="auth-${route.path}" name="tab-${route.path}" value="auth" checked>
              <label for="auth-${route.path}"><span>Auth</span></label>
            </div>
            <div class="option">
              <input type="radio" id="headers-${route.path}" name="tab-${route.path}" value="headers">
              <label for="headers-${route.path}"><span>Headers</span></label>
            </div>
            <div class="option">
              <input type="radio" id="params-${route.path}" name="tab-${route.path}" value="params">
              <label for="params-${route.path}"><span>Params</span></label>
            </div>
            <div class="option">
              <input type="radio" id="body-${route.path}" name="tab-${route.path}" value="body">
              <label for="body-${route.path}"><span>Body</span></label>
            </div>
          </div>
          <div id="auth-content-${route.path}" class="tab-content">
            <div class="form-group">
              <label for="auth-input-${route.path}">Authorization:</label>
              <input type="text" id="auth-input-${route.path}" placeholder="Bearer token" class="auth-input">
            </div>
          </div>
          <div id="headers-content-${route.path}" class="tab-content" style="display:none;">
            <div class="form-group">
              <label for="headers-editor-${route.path}">Headers (JSON):</label>
              <div id="headers-editor-${route.path}" class="editor"></div>
            </div>
          </div>
          <div id="params-content-${route.path}" class="tab-content" style="display:none;">
            <div class="form-group">
              <label for="params-editor-${route.path}">Params (JSON):</label>
              <div id="params-editor-${route.path}" class="editor"></div>
            </div>
          </div>
          <div id="body-content-${route.path}" class="tab-content" style="display:none;">
            <div class="form-group">
              <label for="body-editor-${route.path}">Request Body (JSON):</label>
              <div id="body-editor-${route.path}" class="editor"></div>
            </div>
          </div>
          <div class="form-group">
            <button class="send-button" onclick="sendRequest('${route.method}', '${route.path}')">Send Request</button>
          </div>
        `;

        endpointSection.innerHTML = html;

        // Initialize Ace Editor for request body, headers, and params
        const bodyEditor = ace.edit(`body-editor-${route.path}`);
        bodyEditor.setTheme("ace/theme/github");
        bodyEditor.session.setMode("ace/mode/json");
        bodyEditor.setOptions({
          enableBasicAutocompletion: true,
          enableLiveAutocompletion: true
        });

        const headersEditor = ace.edit(`headers-editor-${route.path}`);
        headersEditor.setTheme("ace/theme/github");
        headersEditor.session.setMode("ace/mode/json");
        headersEditor.setOptions({
          enableBasicAutocompletion: true,
          enableLiveAutocompletion: true
        });

        const paramsEditor = ace.edit(`params-editor-${route.path}`);
        paramsEditor.setTheme("ace/theme/github");
        paramsEditor.session.setMode("ace/mode/json");
        paramsEditor.setOptions({
          enableBasicAutocompletion: true,
          enableLiveAutocompletion: true
        });

        // Add event listeners for tab switching
        document.querySelectorAll(`input[name="tab-${route.path}"]`).forEach(input => {
          input.addEventListener('change', () => {
            document.querySelectorAll(`.tab-content`).forEach(content => {
              content.style.display = 'none';
            });
            document.getElementById(`${input.value}-content-${route.path}`).style.display = 'block';
            updatePillPosition();
          });
        });

        // Initialize the segmented control
        updatePillPosition();
      });

      routesContainer.appendChild(routeElement);
    });
  } catch (error) {
    console.error('Error parsing routes data:', error);
  }
});

document.addEventListener("DOMContentLoaded", setup);

function setup() {
    document.querySelectorAll(".ios13-segmented-control").forEach(control => {
        control.addEventListener("change", updatePillPosition);
    });
    window.addEventListener("resize", updatePillPosition);
    updatePillPosition(); // Initial call to set the pill position
}

function updatePillPosition() {
    document.querySelectorAll(".ios13-segmented-control").forEach(control => {
        const selectedOption = control.querySelector("input:checked");
        const index = Array.from(control.querySelectorAll("input")).indexOf(selectedOption);
        const selection = control.querySelector(".selection");
        selection.style.transform = `translateX(${selectedOption.offsetWidth * index}px)`;
    });
}

window.addEventListener('resize', updatePillPosition);




function showTab(tabId) {
  const tabContents = document.querySelectorAll('.tab-content');
  tabContents.forEach(tabContent => {
    tabContent.style.display = 'none';
  });
  document.getElementById(tabId).style.display = 'block';
}




function sendRequest(method, path) {
  const bodyEditor = ace.edit(`body-editor-${path}`);
  const headersEditor = ace.edit(`headers-editor-${path}`);
  const paramsEditor = ace.edit(`params-editor-${path}`);
  const requestBody = bodyEditor.getValue().trim();
  const requestHeaders = headersEditor.getValue().trim();
  const requestParams = paramsEditor.getValue().trim();
  const authToken = document.getElementById(`auth-input-${path}`).value.trim();
  const responseOutput = document.getElementById('response-content');
  const statusCodeOutput = document.createElement('div');
  const responseTimeOutput = document.createElement('div');
  const responseSizeOutput = document.createElement('div');
  const responseDataOutput = document.createElement('div');
  const errorMessageOutput = document.createElement('div');

  responseOutput.innerHTML = ''; // Clear previous response data
  responseOutput.appendChild(statusCodeOutput);
  responseOutput.appendChild(responseTimeOutput);
  responseOutput.appendChild(responseSizeOutput);
  responseOutput.appendChild(responseDataOutput);
  responseOutput.appendChild(errorMessageOutput);

  // Only set the body if it is not empty and the method is not GET
  const body = (method !== 'GET' && requestBody) ? requestBody : undefined;

  const requestHeadersObj = {
    'Content-Type': 'application/json',
    ...JSON.parse(requestHeaders || '{}')
  };

  if (authToken) {
    requestHeadersObj['Authorization'] = authToken;
  }

  const headers = requestHeadersObj;
  
  const startTime = performance.now();
  
  fetch(path, {
    method: method,
    headers: headers,
    body: body
  })
  .then(response => {
    const endTime = performance.now();
    const elapsedTime = (endTime - startTime).toFixed(2);
  
    // Read the response body to determine its size
    return response.text().then(text => {
      console.log(response);
      const contentLength = response.headers.get('Content-Length') || text.length;
      const sizeInBytes = contentLength === 'unknown' ? 'Unknown' : contentLength;
  
      statusCodeOutput.innerHTML = `<strong>Status Code:</strong> ${response.status}`;
      responseTimeOutput.innerHTML = `<strong>Response Time:</strong> ${elapsedTime} ms`;
      responseSizeOutput.innerHTML = `<strong>Response Size:</strong> ${sizeInBytes} bytes`;
  
      // Display response headers
      const headersOutput = document.createElement('div');
      headersOutput.innerHTML = '<strong>Response Headers:</strong><ul>';
      response.headers.forEach((value, key) => {
        headersOutput.innerHTML += `<li>${key}: ${value}</li>`;
      });
      headersOutput.innerHTML += '</ul>';
      responseOutput.appendChild(headersOutput);
  
      try {
        const data = JSON.parse(text);
        responseDataOutput.innerHTML = `<div id="response-editor" class="editor"></div>`;
        errorMessageOutput.innerHTML = ''; // Clear previous error messages
  
        // Initialize Ace Editor for response data
        const responseEditor = ace.edit("response-editor");
        responseEditor.setTheme("ace/theme/github");
        responseEditor.session.setMode("ace/mode/json");
        responseEditor.setValue(JSON.stringify(data, null, 2), -1);
        responseEditor.setReadOnly(true);
      } catch (e) {
        responseDataOutput.innerHTML = `<pre>${text}</pre>`;
        errorMessageOutput.innerHTML = ''; // Clear previous error messages
      }
    });
  })
  .catch(error => {
    responseDataOutput.innerHTML = ''; // Clear previous response data
    errorMessageOutput.innerHTML = `<pre>Error: ${error.message}</pre>`;
  });
}