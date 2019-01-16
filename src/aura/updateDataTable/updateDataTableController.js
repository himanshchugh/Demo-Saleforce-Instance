({
	populateTable : function(component, event, helper) {
		var heightData = {'himansh':5.7, 'tarun':5.5, 'Dangi':5.8, 'Puneet':5.6, 'Mohsin':5.8}
		var headingMsg = component.get("v.greetingMsg");
		debugger;
		component.set("v.greetingMsg", "List of Employee Heights");
		var listOfNames = component.get("v.listOfNames");
		var listOfHeights = component.get("v.listOfHeights");

		//Generating table
		//Find the table in the component.
		var table = component.find("tableOfHeights").getElement();

		//Flushing the previous data from the table
		table.innerHTML = '';

		//For each Name in the list create two table data elements wrapped up in table row element.
		for (var i in listOfNames) {
			var empHeight = 'N/A';
			if (listOfNames[i] in heightData){
				empHeight = heightData[listOfNames[i]];
			}
			//Create a tr element
			var tbleRowElem = document.createElement("TR");

			//Create row data
			var nameDataElem = document.createElement("TD");
			nameDataElem.appendChild(document.createTextNode(listOfNames[i]));
			var heightDataElem = document.createElement("TD");
			heightDataElem.appendChild(document.createTextNode(empHeight));

			//Adding the data to the row
			tbleRowElem.appendChild(nameDataElem);
			tbleRowElem.appendChild(heightDataElem);

			//appending the row to table
			table.appendChild(tbleRowElem);
		}
	}
})