javascript:
	var elemHL;
	document.addEventListener("mousemove",(m)=>{
		if(elemHL)elemHL.style.boxShadow="none";
		elemHL=m.target;
		elemHL.style.boxShadow="-1px -1px red,-1px 1px red,1px 1px red,-1px 1px red";
	});
void 0;