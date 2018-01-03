<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
</head>

<body>
<div class="heading_4" style="margin-top: -10px;" >
 <center>Mortality Review Form</center>
</div>
<span ><center><g:if test="${latestStatus && (session?.user?.role?.roleName.equals(AdminConstants.ADMIN)) && (mReviewForm?.status.status.equals(MortalityConstants.SUBMITTED) || (mReviewForm?.status.status.equals(MortalityConstants.AMENDED))) }"> ${latestStatus?.updatedStatus} by ${latestStatus?.updatedBy} [${latestStatus?.dateUpdated?.format("MM/dd/yyyy HH:mm")}]  </g:if></center></span>
<div id="mortalityReviewFormDiv" style="min-height: 680px;overflow: auto">
    <g:render template="/mortality/templates/reviewFormLayout"></g:render>
</div>
</body>
</html>
