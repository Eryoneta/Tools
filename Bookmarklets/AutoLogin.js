javascript:
	function loginWorker(doc,username,password){
		let inputs=doc.getElementsByTagName("input");
		let currentInput=null;
		let previousInput=null;
		for(let input of inputs){
			if(input.type==="password"){
				currentInput=input;
				break;
			}
			if(input.type==="text"||input.type==="email")previousInput=input;
		}
		let usernameField=previousInput;
		let passwordField=currentInput;
		if(!usernameField||!passwordField){
			let iframes=doc.getElementsByTagName("iframe");
			for(let iframe of iframes){
				if(!iframe.contentDocument)continue;
				let done=loginWorker(iframe.contentDocument,username,password);
				if(done)return true;
			}
			return false;
		}
		fillField(usernameField,username);
		fillField(passwordField,password);
		return true;
	}
	function fillField(elem,value){
		elem.focus();
		document.execCommand("selectAll",false);
		document.execCommand("insertText",false,value);
		elem.value=value;
	}
	loginWorker(document,"USERNAME","PASSWORD");
void 0;