$( document ).ready( function () {
   
    Ext.create('Ext.container.Viewport', {
        width: '100%',
        height: '100%',
        flex: 1,
        layout: 'border',
        renderTo: Ext.select('.wrap'),
        items: [{
            xtype: 'panel',
            region: 'north',
            layout: {
                type: 'hbox'
            },
            buttonAlign: 'left',
            buttons: [{
                text: 'Перейти к сайту',
                handler: function(el){
                    window.location.href = '../../frontend/web/index.php';
                }
            },{
                text: 'На главную'
            },'->',{
                text: 'Выйти',
                handler: function(el){
                    $.ajax({
                       url: '../web/index.php?r=site/logout',
                       method: 'POST',
                       dataType: 'html',
                       data: {
                           _csrf: 'SE16ekN5anENYFdMKg4vNC01JRMJODA0Oj0cAxYxLUciIRBXcRgYKQ=='
                       },
                       success: function(url){
                            window.location.href = url;
                       }
                    });
                }
            }]
        },{
            region: 'west',
            collapsible: true,
            title: 'Модули',
            width: 250,
            maxWidth: 450,
            minWidth: 150,
            split: true
        }, {
            region: 'center',
            xtype: 'tabpanel',
            activeTab: 0,
            items: []
        }]
    });
    
});