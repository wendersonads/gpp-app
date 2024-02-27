import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { SolicitacaoAstecaModel } from '../models/SolicitacaoAstecaModel';


@Injectable({
  providedIn: 'root'
})
export class AstecaService {

  public astecas: SolicitacaoAstecaModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public post(asteca: SolicitacaoAstecaModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/asteca/`, asteca);
  }

  public add(asteca: SolicitacaoAstecaModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/asteca/`, asteca);
  }

  public get(idx: number): Observable<any>{
    return this.httpClient.get(`${environment.url}/asteca/${idx}`);
    
  }

  public list(): Observable<any>{
    // console.log(this.httpClient.get(`${environment.url}/asteca/`))
    return this.httpClient.get(`${environment.url}/asteca/`);
  }

  public delete(id: number): Observable<any>{
    return this.httpClient.delete(`${environment.url}/asteca/${id}`);
  }

}
