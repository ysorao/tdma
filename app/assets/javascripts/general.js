/*. JAVSCRIPTS VISTA DEL ESPECIALISTA   */

//Vista (app/views/clients/cliente/generate_rips.html.erb)

// Metodo: Filtra por aseguradoras
function autocomplete_insurance(id_field) {
  var field = $('input#'+id_field);
 
  $.get('/api/v1/static_resources/get_insurances.json?term=' + field.val(), function (responses){
    console.log(responses);
    field.autocomplete({
     source: responses,
      focus: function(event, ui){
        field.val(ui.item.label);
      }
    });
  });// end ajax 
}

// Metodo: Filtra por aseguradoras en paciente por el id
function autocomplete_insurance_patient(id_field) {
  var field = $('input#'+id_field);

  if (field.val() == "") {
    $('#insurance').val(0);
  }

  $.get('/api/v1/static_resources/get_insurances.json?term=' + field.val(), function (responses){
    //console.log(responses);
    field.autocomplete({
     source: responses,
      focus: function(event, ui){
        $('#insurance').val(ui.item.id);
      }
    });
  });// end ajax 
}

//Botones adicionales en el modal de la imagen (right, left, up, down y zoom)
function zoomin(index){
  var myImg = document.getElementById("principal"+index);
  var currWidth = myImg.clientWidth;
  if(currWidth == 2500){
      alert("Ha llegado al máximo de zoom");
  } else{
      myImg.style.width = (currWidth + 50) + "px";
  } 
}

function zoomout(index){
  var myImg = document.getElementById("principal"+index);
  var currWidth = myImg.clientWidth;
  if(currWidth == 50){
      alert("Ha llegado al mínimo de zoom");
  } else{
      myImg.style.width = (currWidth - 50) + "px";
  }
}

function move_left(index){
  var a = document.getElementById("principal"+index).style.left;
  document.getElementById("principal"+index).style.left = (parseInt(a.substring(0,a.length-1)) + 50).toString() + "px";
}

function move_right(index){
  var a = document.getElementById("principal"+index).style.left;
  document.getElementById("principal"+index).style.left = (parseInt(a.substring(0,a.length-1)) - 50).toString() + "px";
}

function move_up(index){
  var a = document.getElementById("principal"+index).style.top;
  document.getElementById("principal"+index).style.top = (parseInt(a.substring(0,a.length-1)) + 50).toString() + "px";
}

function move_down(index){
  var a = document.getElementById("principal"+index).style.top;
  document.getElementById("principal"+index).style.top = (parseInt(a.substring(0,a.length-1)) - 50).toString() + "px";
}

var escribir = [];

//Metodo que permite activar un microfono para escribir texto en Google Chrome
function microfone(texto, boton){
  
  $('#'+boton).css("background-color", "green");  
  var ses = new webkitSpeechRecognition();
  ses.lang = "es"

  escribir = [$('#'+texto).val()];
  
  ses.onresult = function(e){
    if (event.results.length > 0) {
      sonuc = event.results[event.results.length - 1];

      escribir.push(sonuc[0].transcript);

      var quitar = escribir.join();

      if(sonuc.isFinal){ 
        $('#'+texto).val(quitar.replace(/,/g , " "));
        $('#'+texto).keyup();   
      }
    }
  }
  ses.start();

  ses.onstart = function() {
    $('#success_notification').show(200).delay(1000).hide(200);
    $('#alert_notification').hide();
    $('#message_success').text("Ha sido activado el micrófono");
  }

  ses.onend = function() {
    
    $('#'+boton).css("background-color", "#337ab7");
    $('#alert_notification').show(200).delay(5000).hide(200);
    $('#success_notification').hide();
    $('#message_error').text("Se ha desactivado el micrófono");
  }
}

//Permite convertir los input de texto a minusculas y mayuscula capital (Respuesta especialista)
function write_input(id){
  $('#'+id).keyup(function(event) {
    var textBox = event.target;
    textBox.value = textBox.value.toLowerCase();
    var rg = /(^\w{1}|\.\s*\w{1}|\n\s*\w{1})/gi;
    textBox.value = textBox.value.replace(rg, function(toReplace) {
        return toReplace.toUpperCase();
    }); 
  });
}

//Permite mover la imagen con el mouse en el modal de imagenes
function drag_image(index){
  Draggable.create("#principal"+index, {
    type:"x,y"
  });
}

//Permite calcular los años o meses o dias desde una fecha de nacimiento
function Edad(FechaNacimiento) {
  //mes/dia/año
  var temp_date = FechaNacimiento.replace(/([0-9]+)\/([0-9]+)\/([0-9]+)/,"$2/$1/$3");
  var mda = temp_date.split('/');
  var birthday = new Date(mda[2], mda[0]-1, mda[1]);
  //var mdb = "01/01/2012".split('/');
  //var current_date = new Date(mdb[2], mdb[0]-1, mdb[1]);
  var current_date = new Date();
  var days = Math.round((current_date-birthday)/(1000*60*60*24) -1);
  // revision de dias
  if(days <= 28){
    $('#patient_patient_informations_attributes_0_age').val(days);
    $('#patient_patient_informations_attributes_0_unit_measure_age option:eq(2)').prop('selected', 'selected');
    console.log("TIENES DIAS DE NACIDO: ",days);
  }else{
    var months = Math.round(days/30);
    if(months <= 12){
      var months_no_round = days/30;
      var days_rest = Math.round((months_no_round%1)*30) -1;
      $('#patient_patient_informations_attributes_0_age').val(months); 
      $('#patient_patient_informations_attributes_0_unit_measure_age option:eq(1)').prop('selected', 'selected');
      console.log("TIENES MESES DE NACIDO: ",months);
      console.log("CON TANTOS DIAS", days_rest);
    }else{
      var years = Math.round(months/12) -1;
      $('#patient_patient_informations_attributes_0_age').val(years);
      $('#patient_patient_informations_attributes_0_unit_measure_age option:eq(0)').prop('selected', 'selected'); 
      console.log("TIENES AÑOS DE NACIDO: ",years);
      //var years_no_round = months/12;
      //var months_rest = Math.round((years_no_round%1)*12);
      //console.log("CON TANTOS MESES", months_rest);

      //var months_no_round = (years_no_round%1)*12;
      //var days_rest = Math.round((months_no_round%1)*30);  
      //console.log("CON TANTOS DIAS", days_rest); 
    }
  }
}

//Cambiar imagen original del modal por la que se escoge de las dermatoscopicas
function choose_image(index_padre ,index, dermatoscopy_id){
  $('#principal'+index_padre).attr("src", $('#dermatoscopy'+index).attr('src'));
  $('#field_id').val(dermatoscopy_id);
  $('.box_images').hide();
  $('#dermat_window'+index_padre).prop('disabled', true);
  setTimeout(function(){
    $('.cerrar_dermat'+index_padre).show();
  }, 100);
}