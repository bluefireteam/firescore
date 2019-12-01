import { connect } from "react-redux";
import Login from "../components/Login";
import { withRouter } from 'react-router-dom'

const mapStateToProps = ({ session: { loading } }) => {
    return { loading }
}

const mapDispatchToProps = (dispatch, { history }) => {
    return {
        login: (username, password) => {
            dispatch({type: "LOGIN_STARTED"})
            const token = btoa(username + ":" + password);
            
            const headers = new Headers();
            headers.set('Authorization', 'Basic ' + token);

            fetch(`https://api.score.fireslime.xyz/admin/account`, { headers })
            .then(resp => {
                return resp.json()
            })
            .then(account => {
                dispatch({type: "LOGIN_DONE", payload: { account, token }})
                // history.push("/scorelist")
            })
            .catch(error => {
                console.log("Fail to login", error)
            })
        }
    }
}

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Login))