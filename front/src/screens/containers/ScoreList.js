import { connect } from "react-redux";
import { withRouter } from 'react-router-dom'
import ScoreList from "../components/ScoreList";
import { fetchScoreList } from "../../actions/scorelist"

const mapStateToProps = ({ score: { scores, loading }}) => {
    return { scores, loading }
}

const mapDispatchToProps = (dispatch, { match: { params: { uuid }}}) => {
    return {
        fetchScores: () => dispatch(fetchScoreList(uuid))
    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ScoreList))