/*New Stuff*/
		translateButtonPressed: function() {
			var self = this;
			var aLangName = ["German", "Spanish (Spain)", "French (France)", "Italian", "Portuguese (Brazil)", "Croatian",
				"Slovenian"
			];
			var aLangCode = ["de", "es", "fr", "it", "pt", "hr", "sl"];
			var oldText = this.getView().byId("OldText").getValue();
			var newLang = this.getView().byId("NewLang").getSelectedItem();
			if (newLang !== null) {
				//var oldLangCode = aLangCode[aLangName.indexOf(oldLang.mProperties.text)];     
				var newLangCode = aLangCode[aLangName.indexOf(newLang.mProperties.text)];
				var data = "{\r\n  \"sourceLanguage\":en,\r\n  \"targetLanguages\": [\r\n " + newLangCode +
					"   \r\n  ],\r\n  \"units\": [\r\n    {\r\n      \"value\":\"" + oldText + "\"\r\n    }\r\n  ]\r\n}";
				var xhr = new XMLHttpRequest();
				xhr.withCredentials = true;
				xhr.addEventListener("readystatechange", function() {
					if (this.readyState === this.DONE) {
						sap.m.MessageToast.show("Translated!");
						self.getView().byId("NewText").setValue(JSON.parse(this.responseText).units[0].translations[0].value);
					}
				});
				//setting request method
				xhr.open("POST", "https://sandbox.api.sap.com/translationhub/api/v1/translate");

				//adding request headers
				xhr.setRequestHeader("Content-Type", "string");
				xhr.setRequestHeader("Accept", "application/json; charset=utf-8");
				xhr.setRequestHeader("APIKey", "YOUR_KEY");

				//sending request
				xhr.send(data);
			} else {
				var dialog = new sap.m.Dialog({
					title: 'Missing Language',
					type: 'Message',
					state: 'Error',
					content: new sap.m.Text({
						text: "Please select a language."
					}),
					beginButton: new sap.m.Button({
						text: 'OK',
						press: function() {
							dialog.close();
						}
					}),
					afterClose: function() {
						dialog.destroy();
					}
				});
				dialog.open();
			}
		},
		/*End of New Stuff*/