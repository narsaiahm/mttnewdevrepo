<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<div>
    <g:if test="${auditList}">
        <g:each in="${auditList}" var="audit">


            <g:if test="${audit.updatedStatus == MortalityConstants.UNASSIGNED}">
                <li class = "li_statusHistoryFormat"> ${audit.updatedStatus} %{--[Form Status : Unassigned]--}%
                    <br>
                    <span class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:if>

            <g:elseif test="${audit.updatedStatus == MortalityConstants.ACCEPTED || audit.updatedStatus == MortalityConstants.UPDATED}">
                <li class = "li_statusHistoryFormat"> ${audit.updatedStatus} %{--[Form Status : Assigned: Incomplete]--}%
                    <br>
                    <span class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:elseif>

            <g:if test="${audit.updatedStatus == MortalityConstants.REMINDER || audit.updatedStatus == MortalityConstants.REMINDER_14_DAYS}">
                <li class = "li_statusHistoryFormat"> ${audit.updatedStatus} %{--[Form Status : Unassigned]--}%
                    <br>
                    <span class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:if>

            <g:elseif test="${audit.updatedStatus == MortalityConstants.ASSIGNED}">
                <li  class = "li_statusHistoryFormat"> ASSIGNED to ${audit.assignedUser} %{--[Form Status : Assigned: Incomplete]--}%
                    <br>
                    <span  class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:elseif>

            <g:elseif test="${audit.updatedStatus == MortalityConstants.REASSIGNED }">
                <li class = "li_statusHistoryFormat"> REASSIGNED to ${audit.assignedUser} %{--[Form Status : Assigned: Incomplete]--}%
                    <br>
                    <span class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:elseif>

            <g:elseif test="${audit.updatedStatus == MortalityConstants.SUBMITTED || audit.updatedStatus == MortalityConstants.AMENDED}">
                <li class = "li_statusHistoryFormat">${audit.updatedStatus} %{--[Form Status : Complete]--}%
                    <br>
                    <span class = "span_statusHistoryFormat"><i>by</i> ${audit.updatedBy} (${formatDate(format:'MM/dd/yyyy HH:mm',date:audit.dateUpdated)})</span>
                </li>
            </g:elseif>
        </g:each>
    </g:if>
    <g:else>
        No Data To Show
    </g:else>
</div>