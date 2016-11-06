$(document).ready(function(){
   $('#btn_chatbot').click(function(){
    
        $.ajax({
            type: 'post',
            dataType: 'json',
            url: 'index.php?r=site/chatbot',
            success: function(data){
                console.log(data);
            }
        });
    

   });
   
});    
    