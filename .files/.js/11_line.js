Discord.Line = new (function(){
	let trigger = document.createElement("div");
	trigger.className = "dt-line-trigger";
	let file = new Discord.File("line\\line.png");
	file.readBase64().then(function(b64){
		trigger.style.backgroundImage = "url("+b64+")";
	});
	
	let lineContainer = document.createElement("div");
	lineContainer.className = "dt-modal dt-line-container";
	let packs = new Discord.File("line").listFolders();
	lineContainer.elements = document.createElement("div");
	lineContainer.elements.className = "dt-line-inner";
	for(let i=0;i<packs.length;i++){
		let sticker = document.createElement("div");
		sticker.className = "dt-line-sticker";
		let pack = packs[i].list();
		pack[0].readBase64().then(function(b64){
			sticker.style.backgroundImage = "url("+b64+")";
		});
		sticker.elements = document.createElement("div");
		sticker.elements.className = "dt-line-inner";
		for(let j=0;j<pack.length;j++){
			let s = document.createElement("div");
			s.className = "dt-line-sticker";
			let p = pack[j];
			p.readBase64().then(function(b64){
				s.style.backgroundImage = "url("+b64+")";
			});
			s.addEventListener("click", function(){
				p.read().then(function(file){
					let form = new FormData();
					form.append("content", "");
					form.append("file", file);
					discord.sendMessage(discord.getCurrentChannel(), form);
				});
				modal.hide();
			});
			sticker.elements.appendChild(s);
		}
		sticker.addEventListener("click", function(){
			lineContainer.innerHTML = "";
			lineContainer.appendChild(sticker.elements);
		});
		lineContainer.elements.appendChild(sticker);
	}
	lineContainer.appendChild(lineContainer.elements);
	
	let modal = new Discord.Modal(lineContainer);
	trigger.addEventListener("click", function(){
		lineContainer.innerHTML = "";
		lineContainer.appendChild(lineContainer.elements);
		modal.show();
	});
	
	this.appendTo = function(place){
		place.appendChild(trigger);
	};
})();