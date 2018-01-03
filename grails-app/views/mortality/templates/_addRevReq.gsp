<div class="title">
    <p><span>Additional Review Required</span></p>
</div>

<div class="form-inline row">
    <div class="col-md-12">
        <table class="leftAlign tableAlign">

            <tr>
                <td class="col-md-5">
                    <label>
                        <span class="required">*&nbsp;</span>Does Death Require Further Review?
                    </label>
                </td>
                <td class="col-md-7">
                    <label class="radio-inline">
                        <input type="radio" class="mandatory"  name="doesDeathRequireFurtherRev" onclick="showInfoMsg()" value="true" ${mReviewForm?.doesDeathRequireFurtherRev == true ? 'checked="checked"' : ''} >Yes
                    </label>
                    <label class="radio-inline">
                        <input type="radio" class="mandatory" name="doesDeathRequireFurtherRev" onclick="hideInfoMsg()" value="false" ${mReviewForm?.doesDeathRequireFurtherRev == false ? 'checked="checked"' : '' } >No
                    </label>
                </td>
            </tr>
        </table>
        <span  id="infoMsg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    </div>
</div>