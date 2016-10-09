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
            title: 'Navigation',
            width: 150
            // could use a TreePanel or AccordionLayout for navigational items
        }, {
            region: 'south',
            title: 'South Panel',
            collapsible: true,
            html: 'Information goes here',
            split: true,
            height: 100,
            minHeight: 100
        }, {
            region: 'east',
            title: 'East Panel',
            collapsible: true,
            split: true,
            width: 150
        }, {
            region: 'center',
            xtype: 'tabpanel', // TabPanel itself has no title
            activeTab: 0,      // First tab active by default
            items: {
                title: 'Default Tab',
                html: 'The first tab\'s content. Others may be added dynamically'
            }
        }]
    });
    
});