<%@page import="org.mountsinai.mortalitytriggersystem.MortalityConstants; org.mountsinai.mortalitytriggersystem.AdminConstants"%>
<div class="form-group margin">
    <label id="dischargeDivisionId">MSHS Specialty</label>
    <g:select class="form-control"  from="${specialities}"
              name="speciality" optionKey="id" optionValue="specialityName" noSelection="['':'All']" value="${params?.speciality}"></g:select>
</div>
<div class="form-group margin">

    <label>Forms assigned to </label>
    <br>
    <label id="all" class="radio-inline">
        <input type="radio" id = "assignedTo_all" name="assignedTo" value="ALL"  ${params?.assignedTo.equals(MortalityConstants.ALL)?'checked="checked"':''} onclick="updateQl(this)" checked="checked">All
    </label>
    <label id="qualityId" class="radio-inline">
        <input type="radio" id = "assignedTo_ql" name="assignedTo" value="QUALITY_LEAD" ${params?.assignedTo.equals(AdminConstants.QUALITY_LEAD)?'checked="checked"':''} onclick="updateQl(this)">Clinical Quality Lead
    </label>
    <label class="radio-inline">
        <input name="assignedTo" id = "assignedTo_otherReviewer" type="radio" value="ADHOC" ${params?.assignedTo.equals(AdminConstants.ADHOC)?'checked="checked"':''} onclick="updateQl(this)">Clinical Reviewer
    </label>
    <br><br>
    <div id="form_ql">
        <g:render template="/mortality/templates/adminSearchQL"></g:render>
    </div>
</div>

