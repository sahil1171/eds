function() {
    var dialog = this.findParentByType('dialog'); 
    var value = dialog.getField('./et:layout').getValue(); 

    if (value == 'grid') {
        dialog.getField('./et:maxrow').show(); 
        dialog.getField('./et:maxrow').allowBlank = false; 
        dialog.getField('./et:maxrow').fieldLabel = '* Max Row'; 
    } else {
        dialog.getField('./et:maxrow').hide(); 
        dialog.getField('./et:maxrow').allowBlank = true;
        dialog.getField('./et:maxrow').fieldLabel = 'Max Row';
    }

    dialog.getField('./et:maxrow').validate(); 
}
