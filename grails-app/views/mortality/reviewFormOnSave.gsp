
<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:javascript>
        $(document).ready(function() {
            $('#infoMesage').show();
            if($('#isFormEditable').val()=='true') {
                $('#expectedPatToDieAdmissionYes').is(':checked')
                addErrorClassToRadio();
                reviewAndSubmit(1);
              /*  if ($('#isHospiceYes').is((':checked'))) {
                    hospiceOptionClicked($('#isHospiceYes'))
                }*/
            }
            else{
                $('#cancelId').remove();
            }
        });
    </g:javascript>

</head>
<body>
<div id="mortalityReviewFormDiv">

    <g:render template="/mortality/templates/reviewFormOnSave"></g:render>

</div>
</body>
</html>