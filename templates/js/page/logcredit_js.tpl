<script>
$('document').ready(function()
{
    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	table = $('.table-credits').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "ajax": {
            "url": "/log-credit-serverside",
            "type": "POST"
        },
        "language": {                
                "infoFiltered": ""
            },
		order: [[0, 'desc']],
        columnDefs: [
          {
            width: '20%',
            targets: 0,
          },
          {
            width: '20%',
            targets: 1,
          },
          {
            width: '20%',
            targets: 2,
          },
          {
            width: '20%',
            targets: 3,
          },
          {
            width: '20%',
            targets: 4,
          },
        ],
	});
	function getD(){
        $.ajax({
            url: "{$base_url}serverside/data/get_data.php",
            type: "GET",
            dataType: "JSON",
        	cache: false,
            success: function(data)
            {
        		if(data.response == 1){
       
                }
                if(data.response == 2){
                	swal(`Error`, data.licmsg, `error`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(() => {
                        location.reload()
                    });
                }
                if(data.response == 3){
                	swal(`Error`, data.licmsg, `error`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(() => {
                        location.reload()
                    });
                }
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                swal(`Error`, `Error parsing data.`, `error`, {
                    button: false,
                    closeOnClickOutside: false,
                    timer: 3000
                }).then(() => {
                    location.reload()
                });
            },
            complete: function(){
        
        	}
        });
    }
    getD()
});
</script>