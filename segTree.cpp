#include <bits/stdc++.h>
using namespace std;

int tree[100001*4], A[100001];

void build(int node, int start, int end){
    if(start == end){
        tree[node] = A[start];
    }
    else{
        int mid = (start + end) / 2;
        build(2*node, start, mid);
        build(2*node+1, mid+1, end);
        //tree[node] = tree[2*node] + tree[2*node+1];
        tree[node] = min(tree[2*node], tree[2*node+1]);
    }
}
void update(int node, int start, int end, int idx, int val){
    if(start == end) {
        A[idx] = val;
        tree[node] = val;
    }
    else {
        int mid = (start + end) / 2;
        if(start <= idx and idx <= mid) {
            update(2*node, start, mid, idx, val);
        }
        else {
            update(2*node+1, mid+1, end, idx, val);
        }
        //tree[node] = tree[2*node] + tree[2*node+1];
        tree[node] = min(tree[2*node], tree[2*node+1]);
    }
}

int query(int node, int start, int end, int l, int r){
    if(r < start or end < l){
        return INT_MAX;
    }
    if(l <= start and end <= r){
        return tree[node];
    }
    int mid = (start + end) / 2;
    int p1 = query(2*node, start, mid, l, r);
    int p2 = query(2*node+1, mid+1, end, l, r);
    return min(p1, p2);
}

int main(){
    for(int i = 0; i < 100001*4; i++) tree[i] = INT_MAX;
    //
    int N, Q;
    cin >> N >> Q;
    for(int i = 0; i < N; i++) cin >> A[i];
    build(1, 0, N-1);
    //
    char c;
    int l, r;
    while(Q--){
        cin >> c;
        cin >> l >> r;
        switch(c){
            case 'q':
                cout << query(1, 0, N-1, l-1, r-1) << '\n';
                break;
            case 'u':
                update(1, 0, N-1, l-1, r);
        }
    }
}
