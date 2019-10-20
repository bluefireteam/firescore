import { connect } from "react-redux";
import ScoreList from "../components/ScoreList";

const mapStateToProps = ({ scores, loading }) => {
    return { scores, loading }
}

export default connect(mapStateToProps)(ScoreList)