javascript:
	var elemsHL=[];
	var lim=10;
	document.addEventListener("mousemove",(m)=>{
		contains=false;
		for(let elem of elemsHL)if(elem===m.target)contains=true;
		if(contains)return;
		if(elemsHL[lim-1])elemsHL[lim-1].style.boxShadow="none";
		for(let i=lim-1;i>0;i--){
			elemsHL[i]=elemsHL[i-1];
		}
		elemsHL[0]=m.target;
		m.target.style.boxShadow="-1px -1px red,-1px 1px red,1px 1px red,-1px 1px red";
	});
void 0;