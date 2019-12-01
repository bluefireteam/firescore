import { connect } from "react-redux";
import { withRouter } from 'react-router-dom'
import Login from "../components/Login";
import { login } from "../../actions/login"

const mapStateToProps = ({ session: { loading } }) => {
    return { loading }
}

const mapDispatchToProps = (dispatch, { history }) => {
    return {
        login: (username, password) => dispatch(login(username, password))
            .then(() => history.push("/gamelist")
        )

    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Login))